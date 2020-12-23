#!/bin/bash

# This script will split a single tsv file into 
# two separate files with the first column being 
# OUTPUT_FILE.src and the second column beging
# INPUT_FILE.trg

args=("$@")

INPUT_FILE=${args[0]}
OUTPUT_FILE=${args[1]}

awk -F '\t' -v outname="$OUTPUT_FILE" 'BEGIN \
	{file_src=outname ".src"; file_trg=outname ".trg"}; \
	{print $1 >> file_src; print $2 >> file_trg}' $INPUT_FILE
