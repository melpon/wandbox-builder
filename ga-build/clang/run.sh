#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  # sudo apt-get install -y \
  #   python3-distutils
  exit 0
fi

# clang 14.0.0 以降はリポジトリが統合されてる前提でビルドされるっぽいので、
# ソースのアーカイブから拾ってビルドするのを諦めて git clone してビルドする
if compare_version "$VERSION" ">=" "14.0.0"; then
  git clone --branch llvmorg-${VERSION} --depth 1 https://github.com/llvm/llvm-project.git
  pushd llvm-project
    mkdir build
    pushd build
      export CC=clang
      export CXX=clang++
      LLVM_ENABLE_PROJECTS='-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;libcxx;libcxxabi'
      LLVM_ENABLE_RUNTIMES=""
      if compare_version "$VERSION" ">=" "16.0.0"; then
        # llvm-project 16.0.0 以降はlibcxx, libcxxabi, libunwind, compiler-rtなどは
        # LLVM_ENABLE_PROJECTSではなくLLVM_ENABLE_RUNTIMESで指定しなければならない
        # cf. https://github.com/llvm/llvm-project/commit/258477ed0ab69d334302225322ac81ac974b59fb
        LLVM_ENABLE_PROJECTS='-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra'
        LLVM_ENABLE_RUNTIMES='-DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi'
      fi
      cmake \
        ${LLVM_ENABLE_PROJECTS} \
        ${LLVM_ENABLE_RUNTIMES} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        ../llvm
      make -j`nproc`
      make install
    popd
  popd
  archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
  exit 0
fi

if compare_version "$VERSION" ">=" "3.5.0"; then
  EXT="xz"
else
  EXT="gz"
fi

mkdir -p ~/tmp/clang-$VERSION/
pushd ~/tmp/clang-$VERSION/
  if compare_version "$VERSION" ">=" "9.0.1"; then
    BASEURL="https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERSION"
    CLANGNAME="clang"
  elif compare_version "$VERSION" "==" "8.0.1"; then
    BASEURL="https://github.com/llvm/llvm-project/releases/download/llvmorg-$VERSION"
    CLANGNAME="cfe"
  else
    BASEURL="http://www.llvm.org/releases/$VERSION"
    CLANGNAME="cfe"
  fi

  # llvm
  if compare_version "$VERSION" "==" "3.0"; then
    curl_strict_sha256 \
      $BASEURL/llvm-$VERSION.tar.$EXT \
      $BASE_DIR/resources/llvm-$VERSION.tar.$EXT.sha256
    tar xf llvm-$VERSION.tar.$EXT
    mv llvm-$VERSION.src source
  else
    curl_strict_sha256 \
      $BASEURL/llvm-$VERSION.src.tar.$EXT \
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
    curl_strict_sha256 \
      $BASEURL/clang-$VERSION.tar.$EXT \
      $BASE_DIR/resources/clang-$VERSION.tar.$EXT.sha256
    tar xf clang-$VERSION.tar.$EXT
    mv clang-$VERSION.src source/tools/clang
  elif compare_version "$VERSION" "<=" "3.2"; then
    curl_strict_sha256 \
      $BASEURL/clang-$VERSION.src.tar.$EXT \
      $BASE_DIR/resources/clang-$VERSION.src.tar.$EXT.sha256
    tar xf clang-$VERSION.src.tar.$EXT
    mv clang-$VERSION.src source/tools/clang
  elif compare_version "$VERSION" "==" "3.4"; then
    curl_strict_sha256 \
      $BASEURL/clang-$VERSION.src.tar.$EXT \
      $BASE_DIR/resources/clang-$VERSION.src.tar.$EXT.sha256
    tar xf clang-$VERSION.src.tar.$EXT
    mv clang-$VERSION source/tools/clang
  else
    curl_strict_sha256 \
      $BASEURL/${CLANGNAME}-$VERSION.src.tar.$EXT \
      $BASE_DIR/resources/${CLANGNAME}-$VERSION.src.tar.$EXT.sha256
    tar xf ${CLANGNAME}-$VERSION.src.tar.$EXT
    mv ${CLANGNAME}-$VERSION.src source/tools/clang
  fi

  # compiler-rt
  if compare_version "$VERSION" ">=" "3.1"; then
    curl_strict_sha256 \
      $BASEURL/compiler-rt-$VERSION.src.tar.$EXT \
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
    curl_strict_sha256 \
      $BASEURL/clang-tools-extra-$VERSION.src.tar.$EXT \
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
    curl_strict_sha256 \
      $BASEURL/libcxx-$VERSION.src.tar.$EXT \
      $BASE_DIR/resources/libcxx-$VERSION.src.tar.$EXT.sha256
    tar xf libcxx-$VERSION.src.tar.$EXT
    if compare_version "$VERSION" "==" "3.4"; then
      mv libcxx-$VERSION libcxx
    else
      mv libcxx-$VERSION.src libcxx
    fi
  else
    curl_strict_sha256 \
      $BASEURL/libcxx-$VERSION.src.tar.$EXT \
      $BASE_DIR/resources/libcxx-$VERSION.src.tar.$EXT.sha256
    tar xf libcxx-$VERSION.src.tar.$EXT
    mv libcxx-$VERSION.src source/projects/libcxx

    curl_strict_sha256 \
      $BASEURL/libcxxabi-$VERSION.src.tar.$EXT \
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

  if compare_version "$VERSION" "<" "5.0.0"; then
    sed -i s#\"/usr/include/c++/v1#\"$PREFIX/include/c++/v1# source/tools/clang/lib/Frontend/InitHeaderSearch.cpp
    sed -i s#getDriver\(\).SysRoot\ +\ \"/usr/include/c++/v1\"#\"$PREFIX/include/c++/v1\"# source/tools/clang/lib/Driver/ToolChains.cpp
  fi

  if compare_version "$VERSION" "<=" "9.0.1"; then
    pushd source/projects/compiler-rt
      patch -p1 < $BASE_DIR/resources/new-glibc.patch
    popd
  fi
  if compare_version "$VERSION" ">=" "8.0.0"; then
    if compare_version "$VERSION" "<" "9.0.0"; then
      pushd source
        patch -p2 < $BASE_DIR/resources/missing-include-clang-8.x.patch
      popd
    fi
  fi

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
  pushd build
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
    cmake -G "Unix Makefiles" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      "$ARGS" \
      ../source
    make -j`nproc`
    make install
  popd

  # build libcxx for old version
  if compare_version "$VERSION" "<=" "3.2"; then
    :
  elif compare_version "$VERSION" "<=" "3.5.0"; then
    mkdir build_libcxx
    pushd build_libcxx
      export CC="$PWD/../build/bin/clang"
      export CXX="$PWD/../build/bin/clang++"
      cmake -G "Unix Makefiles" \
        -DLIBCXX_CXX_ABI=libsupc++ "-DCMAKE_SHARED_LINKER_FLAGS="-L/usr/lib/gcc/x86_64-linux-gnu/4.8 -Wl,--start-group,-dn,--whole-archive,-lsupc++,--no-whole-archive,--end-group,-dy"" \
        -DLIBCXX_LIBSUPCXX_INCLUDE_PATHS="/usr/include/c++/4.8;/usr/include/x86_64-linux-gnu/c++/4.8" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        ../libcxx
      make -j`nproc`
      make install
    popd
  fi
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
