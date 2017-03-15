FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      clang \
      cmake \
      git \
      ldc \
      libconfig++-dev \
      libcurl4-openssl-dev \
      libedit-dev \
      llvm-dev \
      wget \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

