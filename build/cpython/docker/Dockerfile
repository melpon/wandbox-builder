FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      make \
      gcc \
      python-minimal \
      libncursesw5-dev \
      libgdbm-dev \
      libc6-dev \
      zlib1g-dev \
      libsqlite3-dev \
      tk-dev \
      libssl-dev \
      openssl \
      libffi-dev \
      git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
