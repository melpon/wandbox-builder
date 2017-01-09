FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      wget \
      git \
      autoconf \
      libtool \
      automake \
      build-essential \
      mono-devel \
      gettext \
      gcc-4.8 \
      g++-4.8 \
      cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

