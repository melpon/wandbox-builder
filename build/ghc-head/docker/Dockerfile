FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      bzip2 \
      g++ \
      git \
      libffi-dev \
      libgmp-dev \
      libtool \
      make \
      ncurses-dev \
      python3-minimal \
      wget \
      xz-utils \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
