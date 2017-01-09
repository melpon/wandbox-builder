#!/bin/bash

set -ex

N=$1
if [ -z "$N" ]; then
  N="0"
fi
for v in `cat VERSIONS | tail -n +$N`; do
  ./install.sh $v
done
