FROM melpon/wandbox:clang

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
