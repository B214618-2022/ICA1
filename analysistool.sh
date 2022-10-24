#!/bin/bash

# Finding the directory of the script...
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Creating a unique temporary directory
ANALYSIS_DIR=`mktemp -d -p "$DIRECTORY"`

#extracts IDs from folder of reads
#ls fastq/ | grep -oP "(?<=\-)(.*?)(?=\_)" > read_ids


#Builds the index
#bowtie2-build /localdisk/data/BPSM/ICA1/Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz genome.fa
#echo "index generated..."

echo "analysing reads..."
analysis(){
   sample_id=$(echo "$1" | awk -F'[-_]' '{print $2}') #Prints IDs of filenames ending in .fq by using - or _ as field separators and choosing field 2, assigns to variable
   bowtie2 -x genome.fa -1 fastq/Tco-${sample_id}_1.fq -2 fastq/Tco-${sample_id}_2.fq -S ${sample_id}tcongoalign.sam
   samtools view -bS ${sample_id}tcongoalign.sam > ${sample_id}tcongoalign.bam
   samtools sort ${sample_id}tcongoalign.bam -o ${sample_id}tcongoalign.sorted.bam
   samtools index ${sample_id}tcongoalign.sorted.bam
   bedtools intersect -a /localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed -b ${sample_id}tcongoalign.sorted.bam -c > output${sample_id}
   echo "intersect count file output${sample_id} generated..."   
   rm ${sample_id}*
}

#cycles through each file in fastq folder and performs comparison

for file in fastq/*1.fq; do #note, the 1.fq pattern is just to make sure it doesn't repeat analysis. It's still using both read pairs.

   analysis $file &
   
done

wait

awk 'NR>1 {print $2 "\n Time" $4 "\n" $5}' $DIRECTORY/fastq/Tco.fqfiles > parameterlist.txt
awk '{ a[$1]++ } END { for (b in a) { print b } }' parameterlist.txt > uniq_params
rm parameterlist.txt

echo "analysis complete"
