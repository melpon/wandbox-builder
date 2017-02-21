FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install -y \
      libmpc3 \
      binutils \
      g++ \
      libc6-dev \
      libgcc-5-dev \
      libstdc++-5-dev \
      libffi6 \
      libgmp-dev \
      clang \
      libedit2 \
      libicu55 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s libgmp.so /usr/lib/x86_64-linux-gnu/libgmp.so.3
