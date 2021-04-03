#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# get binary

case $VERSION in
  "5.0.201" ) URL=https://download.visualstudio.microsoft.com/download/pr/73a9cb2a-1acd-4d20-b864-d12797ca3d40/075dbe1dc3bba4aa85ca420167b861b6/dotnet-sdk-5.0.201-linux-x64.tar.gz ;;
  "3.1.407" ) URL=https://download.visualstudio.microsoft.com/download/pr/ab82011d-2549-4e23-a8a9-a2b522a31f27/6e615d6177e49c3e874d05ee3566e8bf/dotnet-sdk-3.1.407-linux-x64.tar.gz ;;
  "2.1.814" ) URL=https://download.visualstudio.microsoft.com/download/pr/b44d40e6-fa23-4f2d-a0a9-4199731f0b1e/5e62077a9e8014d8d4c74aee5406e0c7/dotnet-sdk-2.1.814-linux-x64.tar.gz ;;
  * ) exit 1 ;;
esac

wget_strict_sha256 $URL $BASE_DIR/resources/dotnet-sdk-${VERSION}-linux-x64.tar.gz.sha256
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
