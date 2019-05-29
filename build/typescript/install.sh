#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION

# get sources

mkdir $PREFIX
cd $PREFIX

# create package.json

echo "{ \"dependencies\": { \"typescript\": \"$VERSION\" } }" > package.json

# install

npm install
PATH=$PREFIX/node_modules/typescript/bin:$PATH
