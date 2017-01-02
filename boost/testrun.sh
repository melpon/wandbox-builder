#!/bin/bash

rm -r test-results || true
rm RESULT || true
mkdir -p test-results
cat VERSIONS | while read line; do
  if [ -z "$line" ]; then
    :
  else
    ./install.sh $line > "test-results/$line.log" 2>&1
    echo "$line: $?" >> RESULT
  fi
done
