#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION
NODE_VERSION=10.16.0

# create dir

mkdir $PREFIX
cd $PREFIX

# create package.json

echo "{ \"dependencies\": { \"typescript\": \"$VERSION\" } }" > package.json

# install nodejs

wget_strict_sha256 \
  https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz \
  $BASE_DIR/resources/node-v$NODE_VERSION/node-v$NODE_VERSION.tar.gz.sha256

tar xf node-v$NODE_VERSION.tar.gz
cd node-v$NODE_VERSION

# build nodejs

./configure --prefix=$PREFIX --partly-static
make -j2
make install

PATH=$PREFIX/bin:$PATH npm update -g

npm install
rm package.json
PATH=$PREFIX/node_modules/typescript/bin:$PATH
