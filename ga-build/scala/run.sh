#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-triple.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  # download sbt
  curl_strict_sha256 \
    https://github.com/sbt/sbt/releases/download/v1.5.1/sbt-1.5.1.tgz \
    $BASE_DIR/resources/sbt-1.5.1.tgz.sha256
  tar xf sbt-1.5.1.tgz
  mv sbt ~/sbt

  # download openjdk
  mkdir -p `dirname $COMPILER_PREFIX`
  pushd `dirname $COMPILER_PREFIX`
    curl -LO https://github.com/melpon/wandbox-builder/releases/download/assets-ubuntu-24.04/$COMPILER-$COMPILER_VERSION.tar.gz
    tar xf $COMPILER-$COMPILER_VERSION.tar.gz
  popd
  exit 0
fi

export JAVA_HOME=$COMPILER_PREFIX/jvm/`cd $COMPILER_PREFIX/jvm/ && ls -1 | head -n1`
PATH="$JAVA_HOME/bin:$PATH"

# これがあると -Werror が設定されて警告がエラーになってしまう
# https://github.com/scala/scala/blob/089bad782805b5d1af6e2f4eca5f7c0ca91c18d6/build.sbt#L49-L55
# https://github.com/sbt/sbt/pull/3672
unset CI
unset BUILD_NUMBER

# get sources
if compare_version $VERSION '<' '3.0.0'; then
  # scala 2.x
  git clone --depth 1 --branch v$VERSION https://github.com/scala/scala.git
  pushd scala
    # build
    ~/sbt/bin/sbt compile
    ~/sbt/bin/sbt dist/mkPack
    cp -r build/pack $PREFIX
  popd
else
  # scala 3.x
  git clone --depth 1 --branch $VERSION https://github.com/scala/scala3.git
  pushd scala3
    # build
    ~/sbt/bin/sbt dist/packArchive
    cp -r dist/target/pack $PREFIX
  popd
fi

cp $BASE_DIR/resources/run-scalac.sh.in $PREFIX/bin/run-scalac.sh
sed -i "s#@java_home@#$JAVA_HOME#g" $PREFIX/bin/run-scalac.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-scalac.sh
chmod +x $PREFIX/bin/run-scalac.sh

cp $BASE_DIR/resources/run-scala.sh.in $PREFIX/bin/run-scala.sh
sed -i "s#@java_home@#$JAVA_HOME#g" $PREFIX/bin/run-scala.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-scala.sh
chmod +x $PREFIX/bin/run-scala.sh


archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
