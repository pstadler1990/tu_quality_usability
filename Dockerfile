FROM python:3

MAINTAINER PS "nomail@spam.com"

# TODO: Create python venv

# TODO: Download moses

# Download subword-nmt
RUN git clone https://github.com/rsennrich/subword-nmt.git

# Install sacrebleu
RUN pip3 install sacrebleu

# Download sockeye conference kit with starter scripts
RUN git clone https://github.com/awslabs/sockeye.git -b arxiv_1217
RUN echo "europarl-v10.de-en" > sockeye/arxiv/code/train.en-de.txt
RUN rm sockeye/arxiv/code/train.lv-en.txt
RUN mkdir data/en-de/
# TODO: echo new variables into env.sh (arxiv)


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
