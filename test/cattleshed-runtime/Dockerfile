FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      binutils \
      libatomic1 \
      libc6-dev \
      libgcc-5-dev \
      libstdc++-5-dev \
      libcap2-bin \
      libboost-system1.58.0 \
      libboost-program-options1.58.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
