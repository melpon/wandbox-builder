FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      bison \
      build-essential \
      git \
      libonig-dev \
      libsqlite3-dev \
      libxml2-dev \
      pkg-config \
      re2c \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

