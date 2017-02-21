FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      git \
      cmake \
      ninja-build \
      clang \
      python \
      uuid-dev \
      libicu-dev \
      icu-devtools \
      libbsd-dev \
      libedit-dev \
      libxml2-dev \
      libsqlite3-dev \
      swig \
      libpython-dev \
      libncurses5-dev \
      pkg-config \
      libblocksruntime-dev \
      libcurl4-openssl-dev \
      autoconf \
      libtool \
      systemtap-sdt-dev \
      libkqueue-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
