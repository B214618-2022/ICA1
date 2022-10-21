#!/bin/bash    

#making sure variables are clear
unset $SEQDATA
unset $OUTDIR

# If no parameter supplied
if [ $# -eq 0 ]
then
        echo -e "\nMissing options!"
        echo "(run $0 -h for help)"
        echo ""
        exit 0
fi

# Help

Help()
{
   echo -e "\n[script synopsis - to be added]" 
   echo
   echo "[script description - to be added]"
   echo
   echo "Syntax: scriptTemplate [-g|h|v|V]"
   echo "options:"
   echo "h     Print this Help."
   echo "i     input directory containing fq.gz sequence data"
   echo "V     Print software version and exit."
   echo
}

# Process script options:

while getopts ":hi:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      i) # Enter sequence data directory path
         SEQDATA=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

# Finding the directory of the script...
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Creating a unique temporary directory
ANALYSIS_DIR=`mktemp -d -p "$DIRECTORY"`

# Checking nothing went wrong
if [[ ! "$ANALYSIS_DIR" || ! -d "$ANALYSIS_DIR" ]]; then
  echo "temporary directory creation failed"
  exit 1
fi

# Handy cleanup function called on exit signal deletes the temporary directory even if the script aborts
#function cleanup {      
#  rm -rf "$ANALYSIS_DIR"
#  echo "Deleted temp working directory $WORK_DIR"
#}

# Catching the EXIT signal and triggering cleanup function
#trap cleanup EXIT

fastqc $SEQDATA/* -o $ANALYSIS_DIR --extract 
