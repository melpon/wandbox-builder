FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      fossil \
      gcc \
      make \
      tcl \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

