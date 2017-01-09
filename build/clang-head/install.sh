#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/clang-head

mkdir -p ~/tmp/clang-head/
cd ~/tmp/clang-head/

# get sources

git clone --depth 1 https://github.com/llvm-mirror/llvm.git source
git clone --depth 1 https://github.com/llvm-mirror/clang.git source/tools/clang
git clone --depth 1 https://github.com/llvm-mirror/compiler-rt.git source/projects/compiler-rt
git clone --depth 1 https://github.com/llvm-mirror/clang-tools-extra.git source/tools/clang/tools/extra
git clone --depth 1 https://github.com/llvm-mirror/libcxx.git source/projects/libcxx
git clone --depth 1 https://github.com/llvm-mirror/libcxxabi.git source/projects/libcxxabi

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

export CC="clang"
export CXX="clang++"
/usr/local/wandbox/camke-3.7.1/bin/cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  ../source
make -j2
make install
cd ..

test_clang $PREFIX "-lc++abi"
