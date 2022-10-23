#!/bin/bash


cut -f6 output5110 > 5110_COUNTS
cut -f6 output5053 > 5053_COUNTS

head -5 5110_COUNTS
head -5 5053_COUNTS

paste 5110_COUNTS 5053_COUNTS > testfile1

#find the mean of $1 and $2 in a file
#awk '{a=int(($2+$3)/2); $2=a; print}' $TEMPCOL
