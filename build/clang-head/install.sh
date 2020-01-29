#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/clang-head

mkdir -p ~/tmp/clang-head/
cd ~/tmp/clang-head/

# get sources

git clone --depth 1 https://github.com/llvm/llvm-project.git

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

export CC="clang-6.0"
export CXX="clang++-6.0"
/usr/local/wandbox/camke-3.16.3/bin/cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;clang-tools-extra;libcxx;libcxxabi" \
  ../llvm-project/llvm
make -j`nproc`
make install
cd ..
