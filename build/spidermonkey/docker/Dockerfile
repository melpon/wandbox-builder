FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      g++ \
      gcc \
      git \
      lbzip2 \
      m4 \
      make \
      patch \
      perl \
      python-minimal \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install autoconf 2.13
RUN wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz && \
    echo "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e *autoconf-2.13.tar.gz" | sha256sum -c && \
    tar xf autoconf-2.13.tar.gz && \
    cd autoconf-2.13 && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -r autoconf-2.13 && \
    rm autoconf-2.13.tar.gz
