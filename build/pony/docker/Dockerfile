FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      git \
      libncurses5-dev \
      libpcre2-dev \
      libssl-dev \
      wget \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install prebuilt LLVM
RUN cd /root && \
    wget http://releases.llvm.org/3.9.1/clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \
    echo "99d1ffd4be8fd3331b4d2478ada7ee6ed352729bfe4a1070450cdb9a3ce8ef9b  clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz" | sha256sum -c && \
    tar xJf clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
      --strip-components 1 \
      -C /usr/local/ \
      clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04 && \
    rm clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
