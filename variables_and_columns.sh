#!/bin/bash

UNINDUCED=$(awk '/Uninduced/ {print $1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
INDUCED=$(awk '/Induced/ {print $1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
CLONE1=$(awk '/Clone1/ {print $1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
CLONE2=$(awk '/Clone2/ {print $1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
WT=$(awk '/WT/ {print $1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
TIME0=$(awk '$4 ~ "0" {print$1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
TIME24=$(awk '$4 ~ "24" {print$1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")
TIME48=$(awk '$4 ~ "48" {print$1}' fastq/Tco.fqfiles | grep -oP "[0-9]{4,}")

GENOMEBED=$"/localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed"

#testing the fold difference in colmeans between Clone1 and WT.
mkdir cutfiles
for x in $CLONE1; do 
   cut -f6 output${x} > cutfiles/cut${x}

done

paste cutfiles/* | column -s $'\t' -t > clone1counts

rm -r cutfiles

mkdir cutfiles
for x in $CLONE2; do
   cut -f6 output${x} > cutfiles/cut${x}

done

paste cutfiles/* | column -s $'\t' -t > clone2counts


awk '{sum=0; for(i=0; i<=NF; i++){sum+=$i}; sum/=NF; print sum}' clone1counts > clone1means
awk '{sum=0; for(i=0; i<=NF; i++){sum+=$i}; sum/=NF; print sum}' clone2counts > clone2means

rm clone1counts
rm clone2counts
rm -r cutfiles
#finding means - to use	later
#awk '{a=int(($2+$3)/2); $2=a; print}' $TEMPCOL
