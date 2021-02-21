FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      build-essential \
      cmake \
      gettext \
      git \
      libtool \
      mono-devel \
      python3 \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
