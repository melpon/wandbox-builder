FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      binutils \
      clang \
      g++ \
      gcc \
      git \
      libboost-all-dev \
      libc6-dev \
      libcap-dev \
      libcap2-bin \
      libedit2 \
      libevent-dev \
      libexpat1 \
      libffi6 \
      libgc-dev \
      libgcc-5-dev \
      libgmp-dev \
      libicu55 \
      libmpc3 \
      libpcre3-dev \
      libstdc++-5-dev \
      m4 \
      make \
      python-dev \
      python3-dev \
      strace \
      vim && \
    apt-get clean

RUN cd /root && \
    git clone --depth 1 https://github.com/melpon/wandbox && \
    cd wandbox/cattleshed && \
    autoreconf -i && \
    ./configure --prefix=/opt/wandbox/cattleshed && \
    make -j2 && \
    make install

COPY clang-head /opt/wandbox/clang-head
COPY zapcc-1.0.1 /opt/wandbox/zapcc-1.0.1
COPY home /root
