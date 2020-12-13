#!/bin/bash
args=("$@")

# This script cuts specified output files (.src, .trg)
# into n smaller files (equally)
# INPUT_FILE(S) argument1
# CUT_NUMBER argument 2
# Example: ./cut_europarl.sh europarl-en_de 10000

INPUT_FILE=${args[0]}
CUT_NUMBER=${args[1]}

echo "Splitting $INPUT_FILE.src into $CUT_NUMBER files"

mkdir cut_files
mkdir cut_files/src
mkdir cut_files/trg

split -l $CUT_NUMBER $INPUT_FILE.src 
mv x* cut_files/src
split -l $CUT_NUMBER $INPUT_FILE.trg
mv x* cut_files/trg

echo "Done, find the files in cut_files/src and cur_files/trg"
