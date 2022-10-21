#!/bin/bash    

#Finding the directory name of the script...
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#creating a unique temporary directory
ANALYSIS_DIR=`mktemp -d -p "$DIRECTORY"`

#checking nothing went wrong
if [[ ! "$ANALYSIS_DIR" || ! -d "$ANALYSIS_DIR" ]]; then
  echo "temporary directory creation failed"
  exit 1
fi

#handy cleanup function called on exit signal deletes the temporary directory even if the script aborts
#function cleanup {      
#  rm -rf "$WORK_DIR"
#  echo "Deleted temp working directory $WORK_DIR"
#}

#Calling the cleanup function
#trap cleanup EXIT
