#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/clang-$VERSION

if compare_version "$VERSION" ">=" "3.5.0"; then
  EXT="xz"
else
  EXT="gz"
fi

mkdir -p ~/tmp/clang-$VERSION/
cd ~/tmp/clang-$VERSION/

# llvm
if compare_version "$VERSION" "==" "3.0"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/llvm-$VERSION.tar.$EXT \
    $BASE_DIR/resources/llvm-$VERSION.tar.$EXT.sha256
  tar xf llvm-$VERSION.tar.$EXT
  mv llvm-$VERSION.src source
else
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/llvm-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/llvm-$VERSION.src.tar.$EXT.sha256
  tar xf llvm-$VERSION.src.tar.$EXT
  if compare_version "$VERSION" "==" "3.4"; then
    mv llvm-$VERSION source
  else
    mv llvm-$VERSION.src source
  fi
fi

# clang
if compare_version "$VERSION" "==" "3.0"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/clang-$VERSION.tar.$EXT \
    $BASE_DIR/resources/clang-$VERSION.tar.$EXT.sha256
  tar xf clang-$VERSION.tar.$EXT
  mv clang-$VERSION.src source/tools/clang
elif compare_version "$VERSION" "<=" "3.2"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/clang-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/clang-$VERSION.src.tar.$EXT.sha256
  tar xf clang-$VERSION.src.tar.$EXT
  mv clang-$VERSION.src source/tools/clang
elif compare_version "$VERSION" "==" "3.4"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/clang-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/clang-$VERSION.src.tar.$EXT.sha256
  tar xf clang-$VERSION.src.tar.$EXT
  mv clang-$VERSION source/tools/clang
else
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/cfe-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/cfe-$VERSION.src.tar.$EXT.sha256
  tar xf cfe-$VERSION.src.tar.$EXT
  mv cfe-$VERSION.src source/tools/clang
fi

# compiler-rt
if compare_version "$VERSION" ">=" "3.1"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/compiler-rt-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/compiler-rt-$VERSION.src.tar.$EXT.sha256
  tar xf compiler-rt-$VERSION.src.tar.$EXT
  if compare_version "$VERSION" "==" "3.4"; then
    mv compiler-rt-$VERSION source/projects/compiler-rt
  else
    mv compiler-rt-$VERSION.src source/projects/compiler-rt
  fi
fi

# clang-tools-extra
if compare_version "$VERSION" ">=" "3.3"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/clang-tools-extra-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/clang-tools-extra-$VERSION.src.tar.$EXT.sha256
  tar xf clang-tools-extra-$VERSION.src.tar.$EXT
  if compare_version "$VERSION" "==" "3.4"; then
    mv clang-tools-extra-$VERSION source/tools/clang/tools/extra
  else
    mv clang-tools-extra-$VERSION.src source/tools/clang/tools/extra
  fi
fi

# libcxx, libcxxabi
if compare_version "$VERSION" "<=" "3.2"; then
  :
elif compare_version "$VERSION" "<=" "3.5.0"; then
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/libcxx-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/libcxx-$VERSION.src.tar.$EXT.sha256
  tar xf libcxx-$VERSION.src.tar.$EXT
  if compare_version "$VERSION" "==" "3.4"; then
    mv libcxx-$VERSION libcxx
  else
    mv libcxx-$VERSION.src libcxx
  fi
else
  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/libcxx-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/libcxx-$VERSION.src.tar.$EXT.sha256
  tar xf libcxx-$VERSION.src.tar.$EXT
  mv libcxx-$VERSION.src source/projects/libcxx

  wget_strict_sha256 \
    http://www.llvm.org/releases/$VERSION/libcxxabi-$VERSION.src.tar.$EXT \
    $BASE_DIR/resources/libcxxabi-$VERSION.src.tar.$EXT.sha256
  tar xf libcxxabi-$VERSION.src.tar.$EXT
  mv libcxxabi-$VERSION.src source/projects/libcxxabi
fi

# apply patches

if compare_version "$VERSION" "<=" "3.5.0"; then
  pushd source/tools/clang
  sed -e "s#@@prefix@@#$PREFIX#" $BASE_DIR/resources/clang-$VERSION-add-searchdir.patch.in | patch -p1
  popd
fi

if compare_version "$VERSION" "==" "3.5.0"; then
  pushd libcxx
  cat $BASE_DIR/resources/libcxx-$VERSION-fix-install-bitsdir.patch | patch -p1
  popd
fi

sed -i s#\"/usr/include/c++/v1#\"$PREFIX/include/c++/v1# source/tools/clang/lib/Frontend/InitHeaderSearch.cpp
sed -i s#getDriver\(\).SysRoot\ +\ \"/usr/include/c++/v1\"#\"$PREFIX/include/c++/v1\"# source/tools/clang/lib/Driver/ToolChains.cpp

# build

mkdir build

# case %{_host_cpu} in
#   i?86* | amd64* | x86_64*) arch="X86" ;;
#   sparc*)               arch="Sparc" ;;
#   powerpc*)             arch="PowerPC" ;;
#   arm*)                 arch="ARM" ;;
#   aarch64*)             arch="AArch64" ;;
#   mips* | mips64*)      arch="Mips" ;;
#   xcore*)               arch="XCore" ;;
#   msp430*)              arch="MSP430" ;;
#   hexagon*)             arch="Hexagon" ;;
#   nvptx*)               arch="NVPTX" ;;
#   s390x*)               arch="SystemZ" ;;
#   *)                    arch="Unknown" ;;
# esac
cd build
if compare_version "$VERSION" "<=" "3.4.2"; then
  export CC="gcc"
  export CXX="g++"
else
  if compare_version "$VERSION" "==" "3.7.1"; then
    export CC="gcc"
    export CXX="g++"
  else
    export CC="clang"
    export CXX="clang++"
  fi
fi
/usr/local/wandbox/camke-3.7.1/bin/cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../source
make -j2
make install
cd ..

# build libcxx for old version
if compare_version "$VERSION" "<=" "3.2"; then
  :
elif compare_version "$VERSION" "<=" "3.5.0"; then
  mkdir build_libcxx
  cd build_libcxx
  export CC="$PWD/../build/bin/clang"
  export CXX="$PWD/../build/bin/clang++"
  /usr/local/wandbox/camke-3.7.1/bin/cmake -G "Unix Makefiles" \
    -DLIBCXX_CXX_ABI=libsupc++ "-DCMAKE_SHARED_LINKER_FLAGS="-L/usr/lib/gcc/x86_64-linux-gnu/4.8 -Wl,--start-group,-dn,--whole-archive,-lsupc++,--no-whole-archive,--end-group,-dy"" \
    -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="/usr/include/c++/4.8;/usr/include/x86_64-linux-gnu/c++/4.8" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    ../libcxx
  make -j2
  make install
  cd ..
fi

if compare_version "$VERSION" "<=" "3.2"; then
  EXTRA_FLAGS="-I/usr/include/c++/5 -I/usr/include/x86_64-linux-gnu/c++/5"
elif compare_version "$VERSION" "<=" "3.5.0"; then
  EXTRA_FLAGS="-stdlib=libc++ -nostdinc++"
else
  EXTRA_FLAGS="-stdlib=libc++ -nostdinc++ -lc++abi"
fi

test_clang $PREFIX "$EXTRA_FLAGS"
