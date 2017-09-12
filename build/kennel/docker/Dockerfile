FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      automake \
      cmake \
      g++ \
      gcc \
      git \
      libcurl4-openssl-dev \
      libgcrypt11-dev \
      libicu-dev \
      libpcre3-dev \
      libsqlite3-dev \
      m4 \
      make \
      python \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# cppcms

RUN git clone --depth 1 https://github.com/melpon/cppcms && \
    mkdir cppcms_build && \
    cd cppcms_build && \
    cmake ../cppcms/ \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local/cppcms \
      -DDISABLE_SHARED=ON \
      -DDISABLE_FCGI=ON \
      -DDISABLE_SCGI=ON \
      -DDISABLE_ICU_LOCALE=ON \
      -DDISABLE_TCPCACHE=ON && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -r cppcms_build && \
    rm -rf cppcms

# cppdb

RUN git clone --depth 1 https://github.com/melpon/cppdb && \
    mkdir cppdb_build && \
    cd cppdb_build && \
    cmake ../cppdb/ \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local/cppdb \
      -DSQLITE_BACKEND_INTERNAL=ON \
      -DDISABLE_MYSQL=ON \
      -DDISABLE_PQ=ON \
      -DDISABLE_ODBC=ON && \
    make && \
    make install && \
    cd .. && \
    rm -r cppdb_build && \
    rm -rf cppdb
