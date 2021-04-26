#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-triple.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  mkdir -p `dirname $COMPILER_PREFIX`
  pushd `dirname $COMPILER_PREFIX`
    curl -LO https://github.com/melpon/wandbox-builder/releases/download/assets-ubuntu-20.04/$COMPILER-$COMPILER_VERSION.tar.gz
    tar xf $COMPILER-$COMPILER_VERSION.tar.gz
  popd
  exit 0
fi

# package.json
echo "{ \"dependencies\": { \"typescript\": \"$VERSION\" } }" > package.json

# install
export PATH=$COMPILER_PREFIX/bin:$PATH

npm update
npm install

mkdir -p $PREFIX/bin
cp -r node_modules $PREFIX/
cp $BASE_DIR/resources/run-tsc.sh.in $PREFIX/bin/run-tsc.sh
sed -i "s#@nodejs_prefix@#$COMPILER_PREFIX#g" $PREFIX/bin/run-tsc.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-tsc.sh

chmod +x $PREFIX/bin/run-tsc.sh

cp $BASE_DIR/resources/run-node.sh.in $PREFIX/bin/run-node.sh
sed -i "s#@nodejs_prefix@#$COMPILER_PREFIX#g" $PREFIX/bin/run-node.sh

chmod +x $PREFIX/bin/run-node.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
