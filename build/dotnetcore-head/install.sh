#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/dotnetcore-head

cd ~/

# get binary

wget https://dotnetcli.blob.core.windows.net/dotnet/Sdk/master/dotnet-sdk-latest-linux-x64.tar.gz
mkdir dotnetcore
tar xf dotnet-sdk-latest-linux-x64.tar.gz -C dotnetcore
rm dotnet-sdk-latest-linux-x64.tar.gz

# install

rm -rf $PREFIX || true
mv dotnetcore $PREFIX

# initialize

export NUGET_PACKAGES=$PREFIX/.nuget/packages

mkdir test
cp $BASE_DIR/resources/test.cs test/Program.cs
pushd test
COREAPP_VERSION=`ls -1 $PREFIX/shared/Microsoft.NETCore.App | head -n 1 | cut -d'.' -f1,2`
echo "
<Project Sdk=\"Microsoft.NET.Sdk\">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp$COREAPP_VERSION</TargetFramework>
  </PropertyGroup>
</Project>
" > test.csproj
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
