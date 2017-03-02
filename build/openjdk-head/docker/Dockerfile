FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get build-dep -y \
      openjdk-8 && \
    apt-get install -y \
      mercurial \
      openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
