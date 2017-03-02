FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      gettext \
      git \
      liblua5.3-dev \
      libperl-dev \
      make \
      python-dev \
      python3-dev \
      ruby-dev \
      tcl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# symlink for lua5.3
RUN ln -s /usr/include/lua5.3 /usr/include/lua && \
    ln -s /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/lib/x86_64-linux-gnu/liblua.a && \
    ln -s /usr/lib/x86_64-linux-gnu/liblua5.3-c++.a /usr/lib/x86_64-linux-gnu/liblua-c++.a
