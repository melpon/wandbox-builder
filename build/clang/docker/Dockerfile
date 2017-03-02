FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      clang \
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

ENV CMAKE_VERSION="3.7.1" \
    CMAKE_SHA256="43cc57605a4f0a3789c463052f66dec3bcce987d204c1aa9b1a9ca5175fad256"

ENV CMAKE_PREFIX="/usr/local/wandbox/camke-${CMAKE_VERSION}"

RUN cd ~/ && \
    wget https://github.com/Kitware/CMake/archive/v${CMAKE_VERSION}.tar.gz && \
    echo "${CMAKE_SHA256} *v${CMAKE_VERSION}.tar.gz" | sha256sum -c && \
    tar xf v${CMAKE_VERSION}.tar.gz && \
    rm v${CMAKE_VERSION}.tar.gz && \
    cd CMake-${CMAKE_VERSION} && \
    ./configure --prefix=$CMAKE_PREFIX && \
    make -j2 && \
    make install && \
    cd ../ && \
    rm -rf CMake-${CMAKE_VERSION}
