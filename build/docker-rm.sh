#!/bin/bash

CONTAINERS=`docker ps -f status=exited -q`
if [ -n "$CONTAINERS" ]; then
    docker rm $CONTAINERS
fi
