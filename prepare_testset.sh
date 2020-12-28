#!/bin/bash
args=("$@")

# Split input file into (un)equal parts
# Usage:
# ./prepare_testset.sh mycorpus.de.tsv output.de 400 100 100
# Splits the file mycorpus.de.tsv into three files output.de.train,
# output.de.dev and output.de.test with 400, 100 and 100 lines

INPUT_FILE=${args[0]}
OUTPUT_FILE=${args[1]}
SPLIT_TRAIN=${args[2]}
SPLIT_DEV=${args[3]}
SPLIT_TEST=${args[4]}

{
    head -n $SPLIT_TRAIN > $OUTPUT_FILE.train
    head -n $SPLIT_DEV > $OUTPUT_FILE.dev
    head -n $SPLIT_TEST > $OUTPUT_FILE.test
} < $INPUT_FILE
