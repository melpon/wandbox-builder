FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      g++ \
      gcc \
      git \
      libboost-all-dev \
      libcap-dev \
      libcap2-bin \
      m4 \
      make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

