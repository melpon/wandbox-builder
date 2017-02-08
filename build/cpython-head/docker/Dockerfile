FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get build-dep -y \
      python-minimal && \
    apt-get install -y \
      zlib1g-dev \
      mercurial && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
