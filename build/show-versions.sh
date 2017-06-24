#!/bin/bash

PATHS="`find . -maxdepth 2 -name VERSIONS | sort`"

for path in $PATHS; do
  compiler=$(basename `dirname $path`)
  if [ `echo $compiler | grep "-head"` ]; then
    # skip
    :
  elif [ $compiler = "boost" ]; then
    :
  else
    echo "---- $compiler ----"
    cat $path
  fi
done
