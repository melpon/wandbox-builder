#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi


case "$VERSION" in
  "3.3.2" ) URL=https://github.com/openssl/openssl/releases/download/openssl-3.3.2/openssl-3.3.2.tar.gz ;;
  "1.1.1w" ) URL=https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1w/openssl-1.1.1w.tar.gz ;;
  "1.1.1k" ) URL=https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1k/openssl-1.1.1k.tar.gz ;;
  "1.0.2u" ) URL=https://openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz ;;
  "0.9.8zh" ) URL=https://openssl.org/source/old/0.9.x/openssl-0.9.8zh.tar.gz ;;
  * ) exit 1 ;;
esac

# get sources

curl_strict_sha256 \
  ${URL} \
  $BASE_DIR/resources/openssl-$VERSION.tar.gz.sha256

tar xf openssl-$VERSION.tar.gz

pushd openssl-$VERSION
  # build
  ./config --prefix=$PREFIX
  make -j`nproc`
  make install
popd

cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
