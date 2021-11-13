#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/luau-$VERSION
CMAKE=/usr/local/wandbox/camke-3.16.3/bin/cmake

# get sources

cd ~/

git clone https://github.com/Roblox/luau.git -b $VERSION
cd luau

# build

mkdir cmake && cd cmake
$CMAKE .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_EXE_LINKER_FLAGS="-static" \
  -DCMAKE_CXX_FLAGS="-Wno-unused-variable"
$CMAKE --build . --target Luau.Repl.CLI --config Release
$CMAKE --build . --target Luau.Analyze.CLI --config Release

mkdir $PREFIX || true

mkdir $PREFIX/bin || true
cp luau* $PREFIX/bin/

mkdir $PREFIX/lib || true
cp *.a $PREFIX/lib/

cp $BASE_DIR/resources/run-luau-analyze.sh.in $PREFIX/bin/run-luau-analyze.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-luau-analyze.sh
chmod +x $PREFIX/bin/run-luau-analyze.sh

rm -r ~/*
