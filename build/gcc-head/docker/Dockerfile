FROM melpon/wandbox:gcc

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      bison \
      flex \
      m4 \
      curl \
      unzip \
      git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

