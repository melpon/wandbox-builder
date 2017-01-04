#!/bin/bash

set -ex

for v in `cat VERSIONS`; do
  ./install.sh $v
done
