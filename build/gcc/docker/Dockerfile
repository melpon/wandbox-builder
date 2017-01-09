FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      wget \
      libgmp-dev \
      libmpfr-dev \
      libmpc-dev \
      libc6-dev-i386 \
      realpath \
      libtool \
      build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

