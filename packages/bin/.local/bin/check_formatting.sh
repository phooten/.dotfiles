#!/bin/bash
usage() { echo "
###############################################################################
#
# File:     check_formatting.sh
#
# Purpose:  Check different files and make sure they abide by the following
#           rules, regaurdless of the language:
#               - Lines <= 120 character
#               - Header with the following details:
#                   - File ( title )
#                   - Description
#                   - Usage
#               - No trailing white spaces
#               - No tabs, only spaces ( exception of make file )
#               - No "TODO" comments, regaurdless of case
#
# Usage:    check_formatting.sh <path-to-file>
#           check_formatting.sh help
#
###############################################################################
">2; exit; }; [ "$1" = "help" ] && usage


# Common lines for consistancy
LINE_A=\
"=============================================================================="
LINE_B=\
"------------------------------------------------------------------------------"
LINE_C=\
"------------------------------"


# Start up information for user
echo ${LINE_A}
echo "Starting script: ${BASH_SOURCE}"
echo


# Gets input file to format
if [[ $# -ne 1 ]]; then
    echo
    echo "Need at least one argument. See '${BASH_SOURCE} help'"
    echo "Exiting script."
    echo
    exit 1
fi


# Checks if file existis
FILE_INPUT=$1
if [[ ! -f ${FILE_INPUT} ]]; then
    echo
    echo "File doesn't exist: ${FILE_INPUT}"
    echo "Exiting script."
    echo
    exit 1
fi


# Checks makefile for spces instead of tabs
if echo ${FILE_INPUT} | grep -q "Makefile"; then
    echo
    echo
    echo ${LINE_C}
    echo Found \[ $(grep -n " .*" ${FILE_INPUT} | wc -l ) \] lines with spaces instead of tabs in \'Makefile\':
    grep -n ' .*' ${FILE_INPUT}
fi


# Checks fo tabs instead of spaces
echo
echo
echo ${LINE_C}
echo Found \[ $(grep -n "\t" ${FILE_INPUT} | wc -l) \] lines with tabs instead of spaces:
grep -n '\t' ${FILE_INPUT}


# Checks for white spaces at the end of lines
echo
echo
echo ${LINE_C}
echo Found \[ $(grep -nE " +$" ${FILE_INPUT} | wc -l) \] lines with trailing white space\(s\):
grep -nE " +$" ${FILE_INPUT}


# Checks line length
LENGTH=120
echo
echo
echo ${LINE_C}
echo Found \[ $(grep -nx ".\{120\}.*" ${FILE_INPUT} | wc -l) \] lines greater than ${LENGTH} characters:
grep -nx ".\{120\}.*" ${FILE_INPUT}


# Checks for any 'TODO' comments
echo
echo
echo ${LINE_C}
echo Found \[ $(grep -Eni '(DEBUG|TODO)' ${FILE_INPUT} | wc -l) \] \'TODO\' / \'DEBUG\' comments:
grep -Eni '(DEBUG|TODO)' ${FILE_INPUT}


# Finishing the script / cleanup
echo
echo
echo ${LINE_A}
echo "Script finished."
