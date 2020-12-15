FROM python:3

MAINTAINER PS "nomail@spam.com"

# Make some dirs for house keeping
RUN mkdir corpus_training_data
RUN mkdir corpus_training_data/raw
RUN mkdir corpus_training_data/split
RUN mkdir custom_scripts

# Get the required custom scripts
RUN git clone https://github.com/pstadler1990/tu_quality_usability.git custom_scripts/

# Download corpus
RUN wget -O europarl-v10.de-en.tsv.gz http://www.statmt.org/europarl/v10/training/europarl-v10.de-en.tsv.gz
RUN gunzip -k europarl-v10.de-en.tsv.gz
RUN mv europarl-v10.de-en.tsv corpus_training_data/raw

# Split europarl single file into src and trg files
RUN ./custom_scripts/split_europarl.sh corpus_training_data/raw/europarl-v10.de-en.tsv europarl-v10.de-en-split
RUN mv europarl-v10.de-en-split.* corpus_training_data/split

# Cut into more, smaller files
# WORKDIR corpus_training_data/split/
RUN ./custom_scripts/cut_europarl.sh corpus_training_data/split/europarl-v10.de-en-split 10000

WORKDIR ../../
#RUN pip3 install torch==1.6.0 torchvision==0.7.0
#RUN pip install torch===1.6.0 torchvision===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install torch torchvision torchaudio
RUN git clone https://github.com/joeynmt/joeynmt.git jnmt/
WORKDIR jnmt

# Unfortunately, there's no release candidate for torch 1.6.0 for my
# systems, so we in-place patch the requirement
RUN sed -i 's/torch==1.6.0/torch/' requirements.txt

RUN pip3 install .
RUN python3 -m unittest

RUN echo "...Done"
