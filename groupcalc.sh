#!/bin/bash


#Defining the groups based on two wordfiles containing group terms
SEARCHIDS1=$(grep -Fw -f wordfile1 fastq/Tco.fqfiles | cut -f1 | grep -oP "[0-9]{4,}")
SEARCHIDS2=$(grep -Fw -f wordfile2 fastq/Tco.fqfiles | cut -f1 | grep -oP "[0-9]{4,}")

GENOMEBED="/localdisk/home/s1653324/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed"

#making files that consist of single columns of expression counts for the first group
mkdir cutfiles
for x in $SEARCHIDS1; do 
   cut -f6 output${x} > cutfiles/cut${x}

done

#pasting the columns together into one file
paste cutfiles/* | column -s $'\t' -t > group1counts

rm -r cutfiles

#Doing the same for the second group
mkdir cutfiles
for x in $SEARCHIDS2; do
   cut -f6 output${x} > cutfiles/cut${x}

done

paste cutfiles/* | column -s $'\t' -t > group2counts

rm -r cutfiles


#Getting the means of each groups counts
awk '{sum=0; for(i=0; i<=NF; i++){sum+=$i}; sum/=NF; print sum}' group1counts > group1means
awk '{sum=0; for(i=0; i<=NF; i++){sum+=$i}; sum/=NF; print sum}' group2counts > group2means

#tidying up
rm group1counts
rm group2counts

#putting the means in two columns
paste group1means group2means > g1xg2

#Creating the group 1 and 2 mean count tables, and cleaning up..
paste $GENOMEBED group1means > Group_1
paste $GENOMEBED group2means > Group_2

rm group1means
rm group2means

#calculating the fold difference (group 2 difference to group 1 (baseline))
awk -f foldcalc.awk g1xg2 > foldchange
rm g1xg2

#finding the absolute values (just removing the minus sign essentially...)
for x in $(cat foldchange); do
   echo "${x##*[+-]}"
done > foldchangeabs

#finally producing the sorted list mapped to the genes...
paste $GENOMEBED foldchangeabs > foldchangegenes
sort -t$'\t' -nk6 -r foldchangegenes > sortedfoldchange

#tidying up
rm foldchangeabs
rm foldchange
rm foldchangegenes
