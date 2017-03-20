FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      bzip2 \
      gcc \
      git \
      make \
      patch \
      sbcl \
      time \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
