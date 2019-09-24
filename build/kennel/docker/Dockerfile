FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      cmake \
      g++ \
      gcc \
      git \
      libcap-dev \
      libcurl4-openssl-dev \
      make \
      python \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
