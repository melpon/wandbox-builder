FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get update && \
    apt-get install -y \
      apt-transport-https \
      clang \
      cmake \
      git \
      libconfig++-dev \
      libclang-common-6.0-dev \
      libcurl4-openssl-dev \
      libedit-dev \
      llvm-6.0-dev \
      wget \
      zlib1g-dev && \
    wget https://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list && \
    apt-get update --allow-insecure-repositories && \
    apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring && \
    apt-get update && \
    apt-get install -y dmd-compiler dub && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

