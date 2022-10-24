#!/bin/bash

DATASOURCE="/localdisk/data/BPSM/ICA1"

#This script first allows the user to select from a list of available parameters, forming two groups, then uses those groups to perform a fold difference calculation - fold difference of group 2 to group 1

echo 'Group 1 parameter selection. Please note, selecting all of one type e.g. Clone1, Clone2 and WT, will effectively select the entire set'
#selecting parameters
PS3=$'\n\n Please select:'
options=$(cat uniq_params) #reading from uniq_params file generated from Tco.fqfiles

#array for parameters
choices=()

select choice in $options Finished
do
  # Stop choosing
  [[ $choice = Finished ]] && break
  # Append the choice to the array
  choices+=( "$choice" )
  echo "$choice added. Select another?"
done

# Write out each choice, save to file, format file into column
printf "You selected the following: "
for choice in "${choices[@]}"
do
  printf "%s " "$choice"
done > group1choices
cat group1choices
echo -e '\n\n'
for x in $(cat group1choices); do echo -e $x; done > group1choicescol
rm group1choices


echo 'Group 2 parameter selection. Please note, selecting all of one type e.g. Clone1, Clone2 and WT, will effectively select the entire set'
#selecting parameters
PS3=$'\n\n Please select:'
options=$(cat uniq_params) #reading from uniq_params file generated from Tco.fqfiles

#array for parameters
choices=()

select choice in $options Finished
do
  # Stop choosing
  [[ $choice = Finished ]] && break
  # Append the choice to the array
  choices+=( "$choice" )
  echo "$choice added. Select another?"
done

# Write out each choice
printf "You selected the following: "
for choice in "${choices[@]}"
do
  printf "%s " "$choice"
done > group2choices
cat group2choices
echo -e '\n\n'
for x in $(cat group2choices); do echo -e $x; done > group2choicescol
rm group2choices


#Defining the groups based on two wordfiles containing group terms
SEARCHIDS1=$(grep -Fw -f group1choicescol readdata/Tco.fqfiles | cut -f1 | grep -oP "[0-9]{4,}")
SEARCHIDS2=$(grep -Fw -f group2choicescol readdata/Tco.fqfiles | cut -f1 | grep -oP "[0-9]{4,}")

GENOMEBED="/localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed"

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


echo 'Calculation completed. Fold change of group 2 compared to group 1 summary file generated: sortedfoldchange'


#tidying up
rm foldchangeabs
rm foldchange
rm foldchangegenes
rm group1choicescol
rm group2choicescol
