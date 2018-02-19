#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/fsharp-head

MONO_PREFIX=/opt/wandbox/mono-5.8.0.108
FSC_PATH=$PREFIX/lib/mono/fsharp/fsc.exe

rm -r $PREFIX || true
cp -r $MONO_PREFIX $PREFIX

cd ~/
mkdir fsharp-head
cd fsharp-head

git clone --depth 1 https://github.com/fsharp/fsharp.git

cd fsharp

# build

export MONO_PATH=$PREFIX
export PATH=$PREFIX/bin:$PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX/lib

# ./autogen.sh --prefix=$PREFIX
make -j2
make install

# run-fsharpc.sh, run-mono.sh

cp $BASE_DIR/resources/run-fsharpc.sh $PREFIX/bin/run-fsharpc.sh
sed -i "s#@MONO_PREFIX@#$PREFIX#g" $PREFIX/bin/run-fsharpc.sh
sed -i "s#@FSC_PATH@#$FSC_PATH#g" $PREFIX/bin/run-fsharpc.sh
chmod +x $PREFIX/bin/run-fsharpc.sh

cp $BASE_DIR/resources/run-mono.sh $PREFIX/bin/run-mono.sh
sed -i "s#@MONO_PREFIX@#$PREFIX#g" $PREFIX/bin/run-mono.sh
chmod +x $PREFIX/bin/run-mono.sh

# version
cd ~/fsharp-head/fsharp
VERSION=`cat mono/appveyor.ps1 | grep '$version = ' | head -n 1 | cut -d"'" -f2`
COMMIT=`git rev-parse HEAD | cut -b -7`
echo "$VERSION-$COMMIT" > $PREFIX/VERSION
