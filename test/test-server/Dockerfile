FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      binutils \
      clang \
      g++ \
      libc6-dev \
      libc6-dev-i386 \
      libedit2 \
      libevent-dev \
      libexpat1 \
      libffi6 \
      libgc-dev \
      libgcc-5-dev \
      libgfortran3 \
      libgmp-dev \
      libicu55 \
      libmpc3 \
      libpcre3-dev \
      libstdc++-5-dev \
      locales \
      python-dev \
      python3-dev && \
    # for kennel deps
    apt-get install -y \
      libcurl4-openssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s libgmp.so /usr/lib/x86_64-linux-gnu/libgmp.so.3

RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
