FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y \
      build-essential \
      cmake \
      curl \
      gcc-8 \
      g++-8 \
      gfortran \
      git \
      m4 \
      make \
      libatomic1 \
      libopenblas-base \
      libopenblas-dev \
      pkg-config \
      perl \
      python3 \
      wget && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 \
      --slave /usr/bin/g++ g++ /usr/bin/g++-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
