#!/bin/bash

set -ex

PREFIX=/opt/wandbox/clang-head

apt-get update
apt-get install -y \
  build-essential \
  clang-12 \
  coreutils \
  git \
  libgcc-10-dev \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libtool \
  python3 \
  wget

CMAKE_VERSION="3.16.3"
CMAKE_SHA256="3e15dadfec8d54eda39c2f266fc1e571c1b88bf32f9d221c8a039b07234206fa"

CMAKE_PREFIX="/usr/local/wandbox/camke-${CMAKE_VERSION}"

wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
echo "${CMAKE_SHA256} *cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" | sha256sum -c
tar xf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
mkdir -p /usr/local/wandbox/
mv cmake-${CMAKE_VERSION}-Linux-x86_64 $CMAKE_PREFIX

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

export CC="clang-12"
export CXX="clang++-12"
/usr/local/wandbox/camke-3.16.3/bin/cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
  -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" \
  ../llvm-project/llvm
make -j`nproc`
make install
