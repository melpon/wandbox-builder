FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      apt-transport-https \
      automake \
      build-essential \
      git \
      libbsd-dev \
      libedit-dev \
      libevent-core-2.0-5 \
      libevent-dev \
      libevent-extra-2.0-5 \
      libevent-openssl-2.0-5 \
      libevent-pthreads-2.0-5 \
      libgc-dev \
      libgmp-dev \
      libgmpxx4ldbl \
      libpcre3-dev \
      libreadline-dev \
      libssl-dev \
      libtool \
      libxml2-dev \
      libyaml-dev \
      llvm \
      wget && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 09617FD37CC06B54 && \
    echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list && \
    apt-get update && \
    apt-get install -y \
      crystal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
