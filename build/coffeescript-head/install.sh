#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/coffeescript-head
NODEJS_PREFIX=/opt/wandbox/nodejs-12.16.2

# get sources

cd ~/
git clone --depth 1 https://github.com/jashkenas/coffeescript.git
cd coffeescript

# build

PATH=$NODEJS_PREFIX/bin:$PATH npm update
PATH=$NODEJS_PREFIX/bin:$PATH npm -g set prefix $PREFIX
PATH=$NODEJS_PREFIX/bin:$PATH npm -g install $(PATH=$NODEJS_PREFIX/bin:$PATH npm pack . | tail -1)

cp $BASE_DIR/resources/run-coffee.sh.in $PREFIX/bin/run-coffee.sh
sed -i "s#@nodejs_prefix@#$NODEJS_PREFIX#g" $PREFIX/bin/run-coffee.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-coffee.sh
chmod +x $PREFIX/bin/run-coffee.sh

echo "`$PREFIX/bin/run-coffee.sh --version | cut -d' ' -f3` `git rev-parse --short master`" > $PREFIX/bin/VERSION

rm -r ~/*
