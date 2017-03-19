#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/coffeescript-$VERSION
NODEJS_PREFIX=/opt/wandbox/nodejs-6.9.5

# get sources

cd ~/
git clone --depth 1 --branch 1.12.3 https://github.com/jashkenas/coffeescript.git
cd coffeescript

# build

PATH=$NODEJS_PREFIX/bin:$PATH npm update
PATH=$NODEJS_PREFIX/bin:$PATH node bin/cake --prefix $PREFIX install

cp $BASE_DIR/resources/run-coffee.sh.in $PREFIX/bin/run-coffee.sh
sed -i "s#@nodejs_prefix@#$NODEJS_PREFIX#g" $PREFIX/bin/run-coffee.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-coffee.sh
chmod +x $PREFIX/bin/run-coffee.sh

rm -r ~/*
