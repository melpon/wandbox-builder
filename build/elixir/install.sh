#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/elixir-$VERSION

if compare_version "$VERSION" ">=" "1.4.5"; then
  ERLANG_VERSION=20.0
elif compare_version "$VERSION" ">=" "1.3.0"; then
  ERLANG_VERSION=19.2
else
  exit 1
fi

cd ~/

wget_strict_sha256 \
  https://github.com/elixir-lang/elixir/archive/v$VERSION.tar.gz \
  $BASE_DIR/resources/v$VERSION.tar.gz.sha256

tar xf v$VERSION.tar.gz

export PATH=/opt/wandbox/erlang-$ERLANG_VERSION/bin:$PATH

cd elixir-$VERSION
export PREFIX
make
make install
cd ..

rm -rf elixir-$VERSION
rm v$VERSION.tar.gz

cp $BASE_DIR/resources/run-elixir.sh.in $PREFIX/bin/run-elixir.sh
chmod +x $PREFIX/bin/run-elixir.sh
sed -i "s/@erlang_version@/$ERLANG_VERSION/g" $PREFIX/bin/run-elixir.sh
sed -i "s/@version@/$VERSION/g" $PREFIX/bin/run-elixir.sh
