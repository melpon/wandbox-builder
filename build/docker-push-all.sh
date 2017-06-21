#!/bin/bash

DIRS="`find . -maxdepth 3 -name Dockerfile | sort`"

NAMES=""
for dir in $DIRS; do
  # basename $(dirname $(dirname "./php-head/docker/Dockerfile"))
  # -> php-head
  NAMES="$NAMES `basename $(dirname $(dirname $dir))`"
done

NAMES="$NAMES cattleshed-conf test-client test-server"

for name in $NAMES; do
  echo "-------- docker push melpon/wandbox:$name --------"
  docker push melpon/wandbox:$name
done
