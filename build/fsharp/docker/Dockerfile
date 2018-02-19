FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y \
      mono-devel && \
    apt-get install -y \
      autoconf \
      automake \
      git \
      libtool \
      make \
      pkg-config \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
