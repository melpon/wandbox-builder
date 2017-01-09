#!/bin/bash

docker rm `docker ps -f status=exited -q`
