#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    bison \
    ruby
  exit 0
fi

# get sources

curl_strict_sha256 \
  https://github.com/mruby/mruby/archive/$VERSION.tar.gz \
  $BASE_DIR/resources/$VERSION.tar.gz.sha256
tar xf $VERSION.tar.gz

pushd mruby-$VERSION
  # config
  sed -i -e "s#conf.gembox 'default'#conf.gembox 'full-core'#" build_config.rb

  # build
  ./minirake
  mkdir $PREFIX -p
  cp -r bin $PREFIX
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
