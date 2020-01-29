FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      clang \
      clang-6.0 \
      libc6-dev-i386 \
      libgmp-dev \
      libmpc-dev \
      libmpfr-dev \
      libstdc++-4.8-dev \
      libtool \
      python \
      realpath \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CMAKE_VERSION="3.16.3" \
    CMAKE_SHA256="3e15dadfec8d54eda39c2f266fc1e571c1b88bf32f9d221c8a039b07234206fa"

ENV CMAKE_PREFIX="/usr/local/wandbox/camke-${CMAKE_VERSION}"

RUN cd ~/ && \
    wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    echo "${CMAKE_SHA256} *cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" | sha256sum -c && \
    tar xf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    mkdir -p /usr/local/wandbox/ && \
    mv cmake-${CMAKE_VERSION}-Linux-x86_64 $CMAKE_PREFIX
