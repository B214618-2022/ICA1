#!/bin/bash

awk 'NR>1 {print $2 "\n" $4 "\n" $5}' fastq/Tco.fqfiles > parameterlist.txt
awk '{ a[$1]++ } END { for (b in a) { print b } }' parameterlist.txt > uniq_params

rm parameterlist.txt
