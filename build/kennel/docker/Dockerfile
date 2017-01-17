FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      gcc \
      g++ \
      make \
      autoconf \
      automake \
      m4 \
      git \
      cmake \
      libpcre3-dev \
      zlib1g-dev \
      libgcrypt11-dev \
      libicu-dev \
      python \
      libsqlite3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

