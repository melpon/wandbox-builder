#!/bin/bash

set -ex

for v in `cat VERSIONS | tail -n +15`; do
  ./install.sh $v
done
