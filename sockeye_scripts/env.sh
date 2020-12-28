# Set this to where you downloaded the data. It expects subdirs en-de and lv-en, which
# contain the training, development, and test data and the BPE models used to produce them
CURDIR=$(pwd)

DATADIR=$CURDIR/../../corpus_training_data
SCRIPTDIR=$CURDIR

# Set this to the language pair you're processing
PAIR="en-de"
SOURCE=$(echo $PAIR | cut -d- -f1)
TARGET=$(echo $PAIR | cut -d- -f2)

# Path to Moses (used for detokenization, validation score)
MOSES=$CURDIR/../moses

# Path to BPE
BPE=$CURDIR/../subword-nmt

# Toolkit Paths
JOEYNMT=$CURDIR/joeynmt
