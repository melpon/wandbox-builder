FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      clang-8 \
      cmake \
      curl \
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
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 100 \
      --slave /usr/bin/clang++ clang++ /usr/bin/clang++-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
