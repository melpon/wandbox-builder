FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      g++ \
      gcc \
      git \
      libbz2-dev \
      libreadline-dev \
      libssl-dev \
      make \
      python-minimal \
      wget \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /root/.pyenv/bin:$PATH
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    echo "eval $(pyenv init -)" >> ~/.bashrc && \
    echo "eval $(pyenv virtualenv-init -)" >> ~/.bashrc && \
    pyenv install 3.8.6 && \
    pyenv global 3.8.6
