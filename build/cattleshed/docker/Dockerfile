FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      gcc \
      g++ \
      make \
      libboost-all-dev \
      autoconf \
      automake \
      m4 \
      git \
      libcap-dev \
      libcap2-bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

