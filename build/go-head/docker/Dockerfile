FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      gcc \
      git \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd ~/ && \
    wget https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz && \
    tar xf go1.4-bootstrap-20161024.tar.gz && \
    rm go1.4-bootstrap-20161024.tar.gz && \
    mv go go1.4 && \
    cd go1.4/src && \
    ./make.bash
