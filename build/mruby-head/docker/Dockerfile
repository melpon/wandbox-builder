FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      binutils \
      bison \
      gcc \
      git \
      ruby && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
