#!/bin/bash

rm -r test-results || true
rm RESULT || true
mkdir -p test-results
N=$1
if [ -z "$N" ]; then
  N="0"
fi
cat VERSIONS | tail -n +$N | while read line; do
  if [ -z "$line" ]; then
    :
  else
    ./install.sh $line > "test-results/$line.log" 2>&1
    echo "$line: $?" >> RESULT
  fi
done
