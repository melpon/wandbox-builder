FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      gcc \
      make \
      tcl \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SQLite HEAD requires fossil 2.0 or later

RUN cd ~/ && \
    wget https://www.fossil-scm.org/xfer/uv/fossil-linux-x64-2.1.tar.gz && \
    echo 'a63989c4444391fd7d7d74a97ec72004cfdf86e54a81c56f0fb934de78abbe71 *fossil-linux-x64-2.1.tar.gz' | sha256sum -c && \
    tar xf fossil-linux-x64-2.1.tar.gz && \
    rm fossil-linux-x64-2.1.tar.gz

ENV PATH /root:$PATH
