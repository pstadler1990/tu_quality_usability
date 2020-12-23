# Set this to where you downloaded the data. It expects subdirs en-de and lv-en, which
# contain the training, development, and test data and the BPE models used to produce them
DATADIR=~/Dokumente/raw/sockeye/arxiv/code/data

# Set this to the language pair you're processing
PAIR="en-de"
SOURCE=$(echo $PAIR | cut -d- -f1)
TARGET=$(echo $PAIR | cut -d- -f2)

# Path to Moses (used for detokenization, validation score)
MOSES=~/Dokumente/tu/raw/moses

# Path to BPE
BPE=~/Dokumente/tu/raw/subword-nmt

# Toolkit Paths
JOEYNMT=/path/to/joeynmt
