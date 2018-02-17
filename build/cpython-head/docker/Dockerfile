FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      git \
      libffi-dev \
      libncursesw5-dev \
      libsqlite3-dev \
      zlib1g-dev && \
    apt-get build-dep -y \
      python \
      python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
