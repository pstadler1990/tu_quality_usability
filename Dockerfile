FROM python:3

MAINTAINER PS "nomail@spam.com"

# Make some dirs for house keeping
RUN mkdir -p custom_scripts/
RUN mkdir -p corpus_training_data/en-de/

# Get the required custom scripts
WORKDIR custom_scripts/
#RUN git init .
#RUN git remote add origin https://github.com/pstadler1990/tu_quality_usability.git
#RUN git pull origin sockeye
RUN git clone https://github.com/pstadler1990/tu_quality_usability.git .
RUN git clone https://github.com/moses-smt/mosesdecoder.git moses/
RUN git clone https://github.com/rsennrich/subword-nmt.git subword-nmt/

# Download corpus
RUN mv europarl-v10-500.de-en.tsv ../corpus_training_data/europarl-v10.de-en.tsv
#WORKDIR ../corpus_training_data/
#RUN wget -O europarl-v10.de-en.tsv.gz http://www.statmt.org/europarl/v10/training/europarl-v10.de-en.tsv.gz
#RUN gunzip -k europarl-v10.de-en.tsv.gz

# Use test corpus

# Split europarl single file into src and trg files
WORKDIR ../
RUN chmod +x custom_scripts/split_europarl.sh
RUN ./custom_scripts/split_europarl.sh corpus_training_data/europarl-v10.de-en.tsv corpus_training_data/en-de/europarl-v10.de-en de en
#RUN mv europarl-v10.de-en.en corpus_training_data/en-de/
#RUN mv europarl-v10.de-en.de corpus_training_data/en-de/

# Python
WORKDIR ../
RUN python3 -m venv venv
RUN . venv/bin/activate
#RUN pip3 install sacrebleu

# Pre-processing
WORKDIR ../custom_scripts/sockeye_scripts/
RUN ./prepare_train.sh 

# Split model into 3 distinct files (train 60%, dev 20%, test 20%)
#WORKDIR ../../corpus_training_data/en-de/
WORKDIR ../../
RUN ./custom_scripts/prepare_testset.sh corpus_training_data/en-de/train.tok.clean.de corpus_training_data/en-de/final.de 300 100 100
RUN ./custom_scripts/prepare_testset.sh corpus_training_data/en-de/train.tok.clean.en corpus_training_data/en-de/final.en 300 100 100

##RUN git clone https://github.com/pstadler1990/joeynmt.git
##WORKDIR joeynmt
##RUN pip3 install .
##RUN python3 -m unittest

# Clone the slightly modified JoeyNMT
#WORKDIR ../../

# TODO: RUN python prepare_new_iteration.py --new-iteration --copy-previous (or --copy-ckpt 14000) --config-file myfile.yaml
# TODO: Copy master config yaml
# TODO: Change fields (python script?!)
# TODO:         - Create model_dir new
# TODO:         - Adjust paths to dev,train,test fils
# TODO:         - If iteration count > 0, add load_model to training with previous
# TODO:           and add vocab dir to point to previous

# TODO: Start learning
# TODO: Use callbacks for housekeeping 
# TODO: If finish, wait

RUN echo "...Done"
