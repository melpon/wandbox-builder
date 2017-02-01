FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      git \
      wget \
      libssl-dev \
      ncurses-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

