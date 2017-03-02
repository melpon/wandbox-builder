FROM melpon/wandbox:gcc

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      bison \
      flex \
      g++ \
      gcc \
      git \
      libgmp3-dev \
      libmpc-dev \
      libmpfr-dev \
      patch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
