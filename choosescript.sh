#!/bin/bash
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

# Write out each choice
printf "You selected the following: "
for choice in "${choices[@]}"
do
  printf "%s " "$choice"
done > group1choices
cat group1choices
echo -e '\n\n'

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

exit 0
