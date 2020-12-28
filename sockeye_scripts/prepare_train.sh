#!/bin/bash

set -eu

echo "Dir: $(dirname $0)"

. $(dirname $0)/env.sh

if [[ ! -d $MOSES ]]; then
    echo "Please set \$MOSES to point to your Moses installation."
    exit 1
fi

if [[ ! -d $BPE ]]; then
    echo "Please set \$BPE to point to your subword-nmt installation."
    exit 1
fi

for pair in en-de; do
    src=$(echo $pair | cut -d- -f1)
    tgt=$(echo $pair | cut -d- -f2)

    [[ ! -d $DATADIR/$pair ]] && mkdir -p $DATADIR/$pair

    # Tokenize, normalize
    for lang in $src $tgt; do
	echo "--> $(cat train.$pair.txt)";
        for prefix in $(cat train.$pair.txt); do
          cat $DATADIR/en-de/$prefix.$lang
	  done | $MOSES/scripts/tokenizer/normalize-punctuation.perl -l $lang \
            | $MOSES/scripts/tokenizer/remove-non-printing-char.perl \
            | $MOSES/scripts/tokenizer/tokenizer.perl -q -no-escape -protected \
	    $MOSES/scripts/tokenizer/basic-protected-patterns -l $lang > $DATADIR/$pair/train.tok.$lang &
    done

    wait

    cd $DATADIR/$pair

    echo "Begin training"

    # Length filtering
    $MOSES/scripts/training/clean-corpus-n.perl train.tok $src $tgt train.tok.clean 1 100

    # BPE training
    cat train.tok.clean.{$src,$tgt} | $BPE/learn_bpe.py -s 32000 > bpe.model

    echo "Done training"

    echo "Begin apply"
    # Apply BPE
    for ext in $src $tgt; do
        cat train.tok.clean.$ext | $BPE/apply_bpe.py -c bpe.model > train.tok.bpe.$ext
    done
    echo "Done apply"

    cd ../../custom_scripts/sockeye_scripts/
done

# Download en-de dev and test sets
#sacrebleu -t wmt15 -l en-de --echo src | ./prepare_devtest.sh $DATADIR/en-de/bpe.model en $DATADIR/en-de/dev
#sacrebleu -t wmt17 -l en-de --echo src | ./prepare_devtest.sh $DATADIR/en-de/bpe.model en $DATADIR/en-de/test

