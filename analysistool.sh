#!/bin/bash

#extracts IDs from folder of reads
#ls fastq/ | grep -oP "(?<=\-)(.*?)(?=\_)" > read_ids

rm -r data_outputs
rm -r readdata

DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATASOURCE="/localdisk/data/BPSM/ICA1"

#Builds the index
bowtie2-build $DATASOURCE/Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz genome.fa
echo "index generated..."

mkdir readdata
for f in $DATASOURCE/fastq/*.gz; do
  STEM=$(basename "${f}" .gz)
  gunzip -c "${f}" > readdata/"${STEM}"
done 

cp $DATASOURCE/fastq/Tco.fqfiles readdata/Tco.fqfiles

echo "analysing reads..."
analysis(){
   sample_id=$(echo "$1" | awk -F'[-_]' '{print $2}') #Prints IDs of filenames ending in .fq by using - or _ as field separators and choosing field 2, assigns to variable
   bowtie2 -x genome.fa -1 readdata/Tco-${sample_id}_1.fq -2 readdata/Tco-${sample_id}_2.fq -S ${sample_id}tcongoalign.sam
   samtools view -bS ${sample_id}tcongoalign.sam > ${sample_id}tcongoalign.bam
   samtools sort ${sample_id}tcongoalign.bam -o ${sample_id}tcongoalign.sorted.bam
   samtools index ${sample_id}tcongoalign.sorted.bam
   bedtools intersect -a $DATASOURCE/TriTrypDB-46_TcongolenseIL3000_2019.bed -b ${sample_id}tcongoalign.sorted.bam -c > output${sample_id}
   echo "intersect count file output${sample_id} generated..."
}

#cycles through each file in fastq folder and performs comparison

for file in readdata/*1.fq; do #note, the 1.fq pattern is just to make sure it doesn't repeat analysis. It's still using both read pairs.

   analysis $file &
   
done

wait

rm *.bam
rm *.bai
rm *.sam


#obtain a list of unique parameters from the fqfiles
awk 'NR>1 {print $2 "\n Time" $4 "\n" $5}' readdata/Tco.fqfiles > parameterlist.txt
awk '{ a[$1]++ } END { for (b in a) { print b } }' parameterlist.txt > uniq_params
rm parameterlist.txt

echo "analysis complete - starting fastqc checks..."


mkdir fastqc
fastqc -t 8 --extract /localdisk/data/BPSM/ICA1/fastq/* -o fastqc
echo "File,Basic Statistics,Per base sequence quality,Per sequence quality scores,Per base sequence content,Per sequence GC content,Per base N content,Sequence Length Distribution,Sequence Duplication Levels,Overrepresented sequences,Adapter Content" > report.csv

rm fastqc/*.html
rm fastqc/*.zip

echo 'generating fastqc report...'

for file in fastqc/* ; do

   awk 'BEGIN{FS="\t";RS="\n";OFS=","} FNR == 1 {print $3}' $file/summary.txt >> report.csv
   awk 'BEGIN{FS="\t";RS="\n";OFS=",";ORS=","} {print $1}' $file/summary.txt >> report.csv
done

echo 'fastqc report generated! - see report.csv' 
