#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION
# node.js install path
NODE_PATH=/opt/wandbox/typescript-env
NODE_VERSION=10.16.0

# create dir

mkdir $PREFIX
cd $PREFIX

PATH=$NODE_PATH/bin:$PATH

# check install node.js
if [ ! -e $NODE_PATH ]; then
  wget_strict_sha256 \
    https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz \
    $BASE_DIR/resources/node-v$NODE_VERSION.tar.gz.sha256

  tar xf node-v$NODE_VERSION.tar.gz
  cd node-v$NODE_VERSION

  # build node.js

  ./configure --prefix=$NODE_PATH --partly-static
  make -j2
  make install
  npm update -g
fi

# create package.json

echo "{ \"dependencies\": { \"typescript\": \"$VERSION\" } }" > package.json

npm install

rm package-lock.json

mkdir $PREFIX/bin
cp $BASE_DIR/resources/run-tsc.sh.in $PREFIX/bin/run-tsc.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-tsc.sh
chmod +x $PREFIX/bin/run-tsc.sh
