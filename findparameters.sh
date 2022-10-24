#!/bin/bash

awk 'NR>1 {print $2 "\n Time" $4 "\n" $5}' fastq/Tco.fqfiles > parameterlist.txt
awk '{ a[$1]++ } END { for (b in a) { print b } }' parameterlist.txt > uniq_params
sort uniq_params
rm parameterlist.txt
