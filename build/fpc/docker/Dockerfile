FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      wget \
      make \
      binutils \
      libc6-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

