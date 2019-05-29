FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
        nodejs \
        npm \
        wget && \
    npm install n -g && \
    n stable && \
    apt purge -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
