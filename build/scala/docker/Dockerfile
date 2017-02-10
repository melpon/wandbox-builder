FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      git \
      wget \
      curl \
      openjdk-8-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > ~/sbt && \
    chmod 0755 ~/sbt && \
    ~/sbt -sbt-create
