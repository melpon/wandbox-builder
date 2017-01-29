#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/rill-head

# llvm

cd ~/
mkdir llvm
cd llvm

VERSION=3.9.1
EXT="xz"
wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/llvm-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/llvm-$VERSION.src.tar.$EXT.sha256
tar xf llvm-$VERSION.src.tar.$EXT
cd llvm-$VERSION.src

mkdir build
cd build
cmake -G 'Unix Makefiles' \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_TARGETS_TO_BUILD="X86" \
      -DLLVM_BUILD_TOOLS=OFF \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_TESTS=OFF \
      ..
cmake --build . --target package/fast -- -j2
cmake --build . --target llc/fast -- -j2
cmake --build . --target llvm-config/fast -- -j2
cmake --build . --target install
cp bin/llvm-config $PREFIX/bin/.
cp bin/llc $PREFIX/bin/.

# rill-head

cd ~/
mkdir rill-head
cd rill-head

eval `opam config env`
PATH=$PATH:$PREFIX/bin LIBRARY_PATH=$LIBRARY_PATH$PREFIX/lib opam install -y llvm.3.9

# get sources

git clone --depth 1 https://github.com/yutopp/rill.git

# build

cd rill
RILL_LLC_PATH=$PREFIX/bin/llc LIBRARY_PATH=$LIBRARY_PATH$PREFIX/lib \
             omake RELEASE=true PREFIX=$PREFIX
RILL_LLC_PATH=$PREFIX/bin/llc LIBRARY_PATH=$LIBRARY_PATH$PREFIX/lib \
             omake test
omake install

cd ~/
rm -r llvm
rm -r rill-head
