FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      bison \
      build-essential \
      curl \
      flex \
      git \
      libc6-dev-i386 \
      libgmp-dev \
      libmpc-dev \
      libmpfr-dev \
      libtool \
      m4 \
      realpath \
      unzip \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
