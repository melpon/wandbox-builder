#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-triple.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  # download erlang
  mkdir -p `dirname $COMPILER_PREFIX`
  pushd `dirname $COMPILER_PREFIX`
    curl -LO https://github.com/melpon/wandbox-builder/releases/download/assets-ubuntu-20.04/$COMPILER-$COMPILER_VERSION.tar.gz
    tar xf $COMPILER-$COMPILER_VERSION.tar.gz
  popd
  exit 0
fi

curl_strict_sha256 \
  https://github.com/elixir-lang/elixir/archive/v$VERSION.tar.gz \
  $BASE_DIR/resources/v$VERSION.tar.gz.sha256

tar xf v$VERSION.tar.gz

export PATH=/opt/wandbox/$COMPILER-$COMPILER_VERSION/bin:$PATH

pushd elixir-$VERSION
  export PREFIX
  make -j`nproc`
  make install
popd

cp $BASE_DIR/resources/run-elixir.sh.in $PREFIX/bin/run-elixir.sh
chmod +x $PREFIX/bin/run-elixir.sh
sed -i "s#@erlang_prefix@#$COMPILER_PREFIX#g" $PREFIX/bin/run-elixir.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-elixir.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
