FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y \
      git \
      gradle \
      openjdk-10-jdk \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV GRADLE_SCANS_ACCEPT=yes
