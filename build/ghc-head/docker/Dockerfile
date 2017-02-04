FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      wget \
      haskell-platform \
      git \
      autoconf \
      automake \
      libtool \
      make \
      libgmp-dev \
      ncurses-dev \
      g++ \
      python \
      bzip2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
