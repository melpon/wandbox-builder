#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/fsharp-$VERSION

if compare_version "$VERSION" "<" "4.0"; then
  MONO_PREFIX=/opt/wandbox/mono-3.12.1
  FSC_PATH=$PREFIX/lib/mono/4.0/fsc.exe
  FLAGS="--with-gacdir=$MONO_PREFIX/lib/mono/gac"
elif compare_version "$VERSION" "<" "4.1"; then
  MONO_PREFIX=/opt/wandbox/mono-5.8.0.108
  FSC_PATH=$PREFIX/lib/mono/4.5/fsc.exe
  FLAGS=""
else
  MONO_PREFIX=/opt/wandbox/mono-5.8.0.108
  FSC_PATH=$PREFIX/lib/mono/fsharp/fsc.exe
  FLAGS=""
fi

cd ~/
mkdir fsharp-$VERSION
cd fsharp-$VERSION

wget_strict_sha256 \
  https://github.com/fsharp/fsharp/archive/$VERSION.tar.gz \
  $BASE_DIR/resources/$VERSION.tar.gz.sha256

tar xf $VERSION.tar.gz
cd fsharp-$VERSION

# build

export MONO_PATH=$MONO_PREFIX
export PATH=$MONO_PREFIX/bin:$PATH
export PKG_CONFIG_PATH=$MONO_PREFIX/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MONO_PREFIX/lib

./autogen.sh --prefix=$PREFIX $FLAGS
make -j2
make install

# run-fsharpc.sh, run-mono.sh

cp $BASE_DIR/resources/run-fsharpc.sh $PREFIX/bin/run-fsharpc.sh
sed -i "s#@MONO_PREFIX@#$MONO_PREFIX#g" $PREFIX/bin/run-fsharpc.sh
sed -i "s#@FSC_PATH@#$FSC_PATH#g" $PREFIX/bin/run-fsharpc.sh
chmod +x $PREFIX/bin/run-fsharpc.sh

cp $BASE_DIR/resources/run-mono.sh $PREFIX/bin/run-mono.sh
sed -i "s#@MONO_PREFIX@#$MONO_PREFIX#g" $PREFIX/bin/run-mono.sh
chmod +x $PREFIX/bin/run-mono.sh

cd ~/
rm -r fsharp-$VERSION
