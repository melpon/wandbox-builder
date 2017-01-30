FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      libmpc3 \
      binutils \
      libc6-dev \
      libgcc-5-dev \
      libstdc++-5-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
