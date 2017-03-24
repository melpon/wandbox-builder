FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install -y \
      binutils \
      clang \
      g++ \
      libc6-dev \
      libedit2 \
      libevent-dev \
      libexpat1 \
      libffi6 \
      libffi6 \
      libgc-dev \
      libgcc-5-dev \
      libgmp-dev \
      libicu55 \
      libmpc3 \
      libpcre3-dev \
      libstdc++-5-dev \
      python-dev \
      python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s libgmp.so /usr/lib/x86_64-linux-gnu/libgmp.so.3
