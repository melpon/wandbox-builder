#!/bin/bash

PWD=$(cd $(dirname $0); pwd)

mkdir -p docker/home/jail/tmp
cp -r $PWD/../../../../wandbox/clang-head $PWD/docker
cp -r $PWD/../../../../wandbox/zapcc-1.0.1 $PWD/docker

docker build docker -t melpon/wandbox:zapcc-issues-sigchld

rm -r $PWD/docker/clang-head
rm -r $PWD/docker/zapcc-1.0.1
