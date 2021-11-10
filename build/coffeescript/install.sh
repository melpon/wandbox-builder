#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/coffeescript-$VERSION
if compare_version "$VERSION" ">=" "2.6.0"; then
  NODEJS_PREFIX=/opt/wandbox/nodejs-12.16.2
else
  if compare_version "$VERSION" ">=" "2.3.0"; then
    NODEJS_PREFIX=/opt/wandbox/nodejs-10.20.1
  else
    if compare_version "$VERSION" ">=" "2.0.0"; then
      NODEJS_PREFIX=/opt/wandbox/nodejs-8.9.0
    else
      NODEJS_PREFIX=/opt/wandbox/nodejs-6.9.5
    fi
  fi
fi

# get sources

cd ~/
git clone --depth 1 --branch $VERSION https://github.com/jashkenas/coffeescript.git
cd coffeescript

# build

PATH=$NODEJS_PREFIX/bin:$PATH npm update
PATH=$NODEJS_PREFIX/bin:$PATH npm -g set prefix $PREFIX
PATH=$NODEJS_PREFIX/bin:$PATH npm -g install $(PATH=$NODEJS_PREFIX/bin:$PATH npm pack . | tail -1)

cp $BASE_DIR/resources/run-coffee.sh.in $PREFIX/bin/run-coffee.sh
sed -i "s#@nodejs_prefix@#$NODEJS_PREFIX#g" $PREFIX/bin/run-coffee.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-coffee.sh
chmod +x $PREFIX/bin/run-coffee.sh

rm -r ~/*
