FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      g++ \
      gfortran \
      libbz2-dev \
      liblzma-dev \
      libpcre3-dev \
      libcurl4-openssl-dev \
      make \
      wget \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

