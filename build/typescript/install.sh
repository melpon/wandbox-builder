#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION
NODEJS_PREFIX=/opt/wandbox/nodejs-6.9.5

# create dir

mkdir $PREFIX
cd ~/

# create package.json

echo "{ \"dependencies\": { \"typescript\": \"$VERSION\" } }" > package.json

# install

PATH=$NODEJS_PREFIX/bin:$PATH npm update
PATH=$NODEJS_PREFIX/bin:$PATH npm install

mkdir $PREFIX/bin
cp -r ~/node_modules $PREFIX/
cp $BASE_DIR/resources/run-tsc.sh.in $PREFIX/bin/run-tsc.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-tsc.sh

chmod +x $PREFIX/bin/run-tsc.sh

cp $BASE_DIR/resources/run-node.sh.in $PREFIX/bin/run-node.sh
sed -i "s#@nodejs_prefix@#$NODEJS_PREFIX#g" $PREFIX/bin/run-node.sh

chmod +x $PREFIX/bin/run-node.sh

rm -r ~/*
