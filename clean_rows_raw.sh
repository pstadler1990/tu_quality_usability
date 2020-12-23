#!/bin/bash

# This script removes all other rows besides the first two
# containing the source and target sentence-aligned translations
# Use the stdout redirection to write the output into a file

# Example:
# ./clean_rows_raw.sh europarl-raw.tsv > my-clean-file.tsv

args=("$@")

INPUT_FILE=${args[0]}

awk -F '\t' -v outname="$OUTPUT_FILE" '{print $1"\t"$2}' $INPUT_FILE
