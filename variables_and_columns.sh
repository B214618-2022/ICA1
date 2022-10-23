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


echo -e $UNINDUCED '\n'
echo -e $INDUCED '\n'
echo -e $CLONE1 '\n'
echo -e $CLONE2 '\n'
echo -e $WT '\n'
echo -e $TIME0 '\n'
echo -e $TIME24 '\n'
echo -e $TIME48 '\n'

#touch expression_table
#for x in $UNINDUCED; do 
#   cut -f6 output${x} > tempcutfile
#   paste expression_table tempcutfile
#
#done




#finding means - to use	later
#awk '{a=int(($2+$3)/2); $2=a; print}' $TEMPCOL
