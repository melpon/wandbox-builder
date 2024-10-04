#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# get binary

case $VERSION in
  "8.0.402" ) URL=https://download.visualstudio.microsoft.com/download/pr/1ebffeb0-f090-4001-9f13-69f112936a70/5dbc249b375cca13ec4d97d48ea93b28/dotnet-sdk-8.0.402-linux-x64.tar.gz ;;
  "6.0.425" ) URL=https://download.visualstudio.microsoft.com/download/pr/f57cd7db-7781-4ee0-9285-010a6435ef4f/ebc5bb7e43d2a288a8efcc6401ce3f85/dotnet-sdk-6.0.425-linux-x64.tar.gz ;;
  * ) exit 1 ;;
esac

curl_strict_sha256 $URL $BASE_DIR/resources/dotnet-sdk-${VERSION}-linux-x64.tar.gz.sha256
mkdir dotnetcore
tar xf dotnet-sdk-${VERSION}-linux-x64.tar.gz -C dotnetcore
rm dotnet-sdk-${VERSION}-linux-x64.tar.gz

# install

rm -rf $PREFIX
mkdir -p `dirname $PREFIX`
mv dotnetcore $PREFIX

# initialize

$PREFIX/dotnet new console -o ./test
pushd ./test
  $PREFIX/dotnet build
  $PREFIX/dotnet run
popd
rm -r ./test

# copy build and run script

mkdir $PREFIX/bin

cp $BASE_DIR/resources/build-dotnet.sh.in $PREFIX/bin/build-dotnet.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/build-dotnet.sh
chmod +x $PREFIX/bin/build-dotnet.sh

cp $BASE_DIR/resources/run-dotnet.sh.in $PREFIX/bin/run-dotnet.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-dotnet.sh
chmod +x $PREFIX/bin/run-dotnet.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
