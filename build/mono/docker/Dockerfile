FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      build-essential \
      cmake \
      g++-4.8 \
      gcc-4.8 \
      gettext \
      git \
      libtool \
      mono-devel \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
