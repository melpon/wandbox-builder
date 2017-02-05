FROM melpon/wandbox:gcc

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      gcc \
      g++ \
      libmpc-dev \
      libmpfr-dev \
      libgmp3-dev \
      autoconf \
      automake \
      flex \
      bison \
      patch \
      git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
