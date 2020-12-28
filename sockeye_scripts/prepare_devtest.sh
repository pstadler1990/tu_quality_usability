#!/bin/bash

. $(dirname $0)/env.sh

bpe_model=$1
lang=$2
prefix=$3

$MOSES/scripts/tokenizer/normalize-punctuation.perl -l $lang \
    | $MOSES/scripts/tokenizer/remove-non-printing-char.perl \
    | $MOSES/scripts/tokenizer/tokenizer.perl -q -no-escape -protected $MOSES/scripts/tokenizer/basic-protected-patterns -l $lang \
    | tee $prefix.tok.$lang \
    | python3 $BPE/apply_bpe.py -c $bpe_model \
    > $prefix.bpe.$lang
