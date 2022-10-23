#!/bin/bash

echo "File,Basic Statistics,Per base sequence quality,Per sequence quality scores,Per base sequence content,Per sequence GC content,Per base N content,Sequence Length Distribution,Sequence Duplication Levels,Overrepresented sequences,Adapter Content" > report.csv

for file in * ; do

   echo $file
   awk 'BEGIN{FS="\t";RS="\n";OFS=","} FNR == 1 {print $3}' $file/summary.txt >> report.csv
   awk 'BEGIN{FS="\t";RS="\n";OFS=",";ORS=","} {print $1}' $file/summary.txt >> report.csv
done
