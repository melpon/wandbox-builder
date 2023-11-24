#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    libgmp-dev \
    libmpc-dev \
    libmpfr-dev
  exit 0
fi

if compare_version "$VERSION" ">=" "4.7.3"; then
  FLAGS="--enable-lto"
else
  FLAGS=""
fi

if compare_version "$VERSION" "<=" "1.42"; then
  :
elif compare_version "$VERSION" "<=" "4.4.7"; then
  export CFLAGS="-fgnu89-inline"
  export CXXFLAGS="-fgnu89-inline"
fi

# get sources

mkdir -p ~/tmp/gcc-$VERSION/
pushd ~/tmp/gcc-$VERSION/
  if compare_version "$VERSION" "<=" "1.42"; then
    curl_strict_sha256 \
      https://gcc.gnu.org/pub/gcc/old-releases/gcc-1/gcc-$VERSION.tar.bz2 \
      $BASE_DIR/resources/gcc-$VERSION.tar.bz2.sha256
    tar xf gcc-$VERSION.tar.bz2
  else
    # http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.gz \
    # https://bigsearcher.com/mirrors/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.gz \
    curl_strict_sha256 \
      https://gcc.gnu.org/pub/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.gz \
      $BASE_DIR/resources/gcc-$VERSION.tar.gz.sha256
    tar xf gcc-$VERSION.tar.gz
  fi

  pushd gcc-$VERSION
    # apply patch
    if compare_version "$VERSION" "<=" "1.42"; then
      patch -p1 -i $BASE_DIR/resources/gcc-1.27.patch
      ln -s config-i386v.h config.h
      ln -s tm-i386v.h tm.h
      ln -s i386.md md
      ln -s output-i386.c aux-output.c
      sed -i "s|^bindir =.*|bindir = $PREFIX/bin|g" Makefile
      sed -i "s|^libdir =.*|libdir = $PREFIX/lib|g" Makefile
    elif compare_version "$VERSION" "<=" "4.5.4"; then
      patch -p1 -i $BASE_DIR/resources/gcc-$VERSION-multiarch.patch
    fi

    if compare_version "$VERSION" ">=" "4.7.0"; then
      if compare_version "$VERSION" "<=" "4.7.4"; then
        # https://github.com/DragonFlyBSD/DPorts/issues/136
        patch -p0 -i $BASE_DIR/resources/gcc-4.7.x-gcc_cp_cfns.patch
      fi
    fi

    # https://stackoverflow.com/questions/63437209/error-narrowing-conversion-of-1-from-int-to-long-unsigned-int-wnarrowi
    if compare_version "$VERSION" ">=" "9.1.0"; then
      if compare_version "$VERSION" "<=" "9.2.0"; then
        sed -e '1161 s|^|//|' -i libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
      fi
    fi

    # glibc-2.28 で sys/ustat.h が消えてるのでパッチを当てる
    if [ -e libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc ] && \
       grep '#include <sys/ustat.h>' libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc; then
      if compare_version "$VERSION" ">=" "5.0.0"; then
        patch -p0 -i $BASE_DIR/resources/glibc-2.28-removed-sys-ustat.patch
      else
        patch -p1 -i $BASE_DIR/resources/glibc-2.28-removed-sys-ustat-gcc-4.patch
      fi
    fi

    # In file included from ../../../../gcc-8.1.0/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc:193:
    # ../../../../gcc-8.1.0/libsanitizer/sanitizer_common/sanitizer_internal_defs.h:317:72: error: size of array 'assertion_failed__1152' is negative
    #      typedef char IMPL_PASTE(assertion_failed_##_, line)[2*(int)(pred)-1]
    # https://github.com/spack/spack/pull/15403
    if compare_version "$VERSION" ">=" "8.1.0"; then
      if compare_version "$VERSION" "<=" "8.3.0"; then
        patch -p1 -i $BASE_DIR/resources/glibc-2.31-libsanitizer-gcc-8.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "9.1.0"; then
      if compare_version "$VERSION" "<=" "9.2.0"; then
        patch -p1 -i $BASE_DIR/resources/glibc-2.31-libsanitizer-gcc-8.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "4.9.0"; then
      if compare_version "$VERSION" "<=" "7.5.0"; then
        patch -p1 -i $BASE_DIR/resources/glibc-2.31-libsanitizer-gcc-6.patch
      fi
    fi

    # ./md-unwind-support.h:65:47: error: dereferencing pointer to incomplete type 'struct ucontext'
    #        sc = (struct sigcontext *) (void *) &uc_->uc_mcontext;
    # https://gcc.gnu.org/git/?p=gcc.git&a=commit;h=883312dc79806f513275b72502231c751c14ff72
    if compare_version "$VERSION" ">=" "7.1.0"; then
      if compare_version "$VERSION" "<" "7.2.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-6-7-use-ucontext_t.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "6.0.0"; then
      if compare_version "$VERSION" "<" "6.5.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-6-7-use-ucontext_t.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "4.9.0"; then
      if compare_version "$VERSION" "<" "5.5.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-6-7-use-ucontext_t.patch
      fi
    fi

    # ../../../../gcc-7.1.0/libsanitizer/sanitizer_common/sanitizer_stoptheworld_linux_libcdep.cc:276:22: error: aggregate 'sigaltstack handler_stack' has incomplete type and cannot be defined
    #    struct sigaltstack handler_stack;
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81066
    if compare_version "$VERSION" ">=" "5.1.0"; then
      if compare_version "$VERSION" "<=" "5.4.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-6-7-sigaltstack.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "6.1.0"; then
      if compare_version "$VERSION" "<=" "6.4.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-6-7-sigaltstack.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "7.1.0"; then
      if compare_version "$VERSION" "<=" "7.2.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-6-7-sigaltstack.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "4.9.0"; then
      if compare_version "$VERSION" "<" "5.0.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-4-sigaltstack.patch
      fi
    fi

    # ../../gcc-5.1.0/gcc/wide-int.h:370:10: error: too many template-parameter-lists
    #   370 |   struct binary_traits <T1, T2, FLEXIBLE_PRECISION, FLEXIBLE_PRECISION>
    # https://github.com/espressif/esp-idf/issues/2126
    if compare_version "$VERSION" ">=" "5.1.0"; then
      if compare_version "$VERSION" "<=" "5.4.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-wide-int.patch
        patch -p1 -i $BASE_DIR/resources/gcc-5-libc_name_p.patch
        patch -p1 -i $BASE_DIR/resources/gcc-5-signal.patch
      fi
    fi
    if compare_version "$VERSION" ">=" "4.9.0"; then
      if compare_version "$VERSION" "<" "5.0.0"; then
        patch -p1 -i $BASE_DIR/resources/gcc-5-signal.patch
      fi
    fi
  popd

  # build
  if compare_version "$VERSION" "<=" "1.42"; then
    pushd gcc-$VERSION
      make
      make stage1
      make CC=stage1/gcc CFLAGS="-O -Bstage1/ -Iinclude"
      make stage2
      make CC=stage2/gcc CFLAGS="-O -Bstage2/ -Iinclude"
      diff cpp stage2/cpp
      diff gcc stage2/gcc
      diff cc1 stage2/cc1
      make install
    popd
  else
    mkdir build
    pushd build
      ../gcc-$VERSION/configure \
        --prefix=$PREFIX \
        --enable-languages=c,c++ \
        --disable-multilib \
        --without-ppl \
        --without-cloog-ppl \
        --enable-checking=release \
        --disable-nls \
        LDFLAGS="-Wl,-rpath,$PREFIX/lib,-rpath,$PREFIX/lib64,-rpath,$PREFIX/lib32" \
        $FLAGS

      if compare_version "$VERSION" "<=" "4.4.7"; then
        sed -i -e "s/CC = gcc/CC = gcc -fgnu89-inline/" Makefile
        sed -i -e "s/CXX = g++/CXX = g++ -fgnu89-inline/" Makefile
      fi

      make -j`nproc`
      make install
    popd
  fi
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
