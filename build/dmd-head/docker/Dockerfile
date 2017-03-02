FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      curl \
      g++ \
      git \
      libcurl4-openssl-dev \
      make \
      unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
