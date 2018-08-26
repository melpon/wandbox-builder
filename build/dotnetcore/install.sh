#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/dotnetcore-$VERSION

cd ~/

# get binary

wget_strict_sha256 \
  https://download.microsoft.com/download/E/8/A/E8AF2EE0-5DDA-4420-A395-D1A50EEFD83E/dotnet-sdk-${VERSION}-linux-x64.tar.gz \
  $BASE_DIR/resources/dotnet-sdk-${VERSION}-linux-x64.tar.gz.sha256
mkdir dotnetcore
tar xf dotnet-sdk-${VERSION}-linux-x64.tar.gz -C dotnetcore
rm dotnet-sdk-${VERSION}-linux-x64.tar.gz

# install

rm -rf $PREFIX || true
mv dotnetcore $PREFIX

# initialize

$PREFIX/dotnet new console -o ~/test
pushd ~/test
$PREFIX/dotnet build
$PREFIX/dotnet run
popd
rm -r ~/test

# copy build and run script

mkdir $PREFIX/bin

cp $BASE_DIR/resources/build-dotnet.sh.in $PREFIX/bin/build-dotnet.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/build-dotnet.sh
chmod +x $PREFIX/bin/build-dotnet.sh

cp $BASE_DIR/resources/run-dotnet.sh.in $PREFIX/bin/run-dotnet.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-dotnet.sh
chmod +x $PREFIX/bin/run-dotnet.sh
