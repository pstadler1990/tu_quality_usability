#!/bin/bash
args=("$@")

# This script cuts specified output files (.src, .trg)
# into n smaller files (equally)
# line / file mode
# CUT_NUMBER argument 1
# INPUT_FILE(S) argument 2
# Example: ./cut_europarl.sh -l 10000 europarl-en_de    Cut into files with line length 10000
# Example 2: ./cut_europarl.sh -f 100 europarl-en_de    Cut into 100 files 

INPUT_FILE=${args[2]}

mode=""
while getopts ":f:l:" opt; do
    case $opt in
        f) mode="file"; CUT_NUMBER=$OPTARG; echo "ok file";
        ;;
        l) mode="line"; CUT_NUMBER=$OPTARG; echo "no line";
        ;;
        \?) echo "Error, invalid argument -$OPTARG" >&2; exit;
        ;;
    esac
done

if [[ "$mode" == "file" ]]; then
    echo "Splitting $INPUT_FILE into $CUT_NUMBER files"
    INPUT_LINES=$(wc -l $INPUT_FILE | awk '{print $1}')
    CALC_LINES_PER_FILE=$((INPUT_LINES / $CUT_NUMBER))
    split -l $CALC_LINES_PER_FILE $INPUT_FILE
else 
    echo "Splitting $INPUT_FILE into files with $CUT_NUMBER lines"
    split -l $CUT_NUMBER $INPUT_FILE
fi

echo "...done"
