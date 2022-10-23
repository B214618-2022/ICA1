#!/bin/bash

UNINDUCED=$(awk '/Uninduced/ {print $1}' fastq/Tco.fqfiles)
INDUCED=$(awk '/Induced/ {print $1}' fastq/Tco.fqfiles)
CLONE1=$(awk '/Clone1/ {print $1}' fastq/Tco.fqfiles)
CLONE2=$(awk '/Clone2/ {print $1}' fastq/Tco.fqfiles)
WT=$(awk '/WT/ {print $1}' fastq/Tco.fqfiles)
TIME0=$(awk '$4 ~ "0" {print$1}' fastq/Tco.fqfiles)
TIME24=$(awk '$4 ~ "24" {print$1}' fastq/Tco.fqfiles)
TIME48=$(awk '$4 ~ "48" {print$1}' fastq/Tco.fqfiles)

GENOMEBED=$"/localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed"


echo -e $UNINDUCED '\n'
echo -e $INDUCED '\n'
echo -e $CLONE1 '\n'
echo -e $CLONE2 '\n'
echo -e $WT '\n'
echo -e $TIME0 '\n'
echo -e $TIME24 '\n'
echo -e $TIME48 '\n'
echo -e $GENOMEBED '\n'
