#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/kennel

# get sources

cd ~/
git clone --depth 1 https://github.com/melpon/cppcms
git clone --depth 1 https://github.com/melpon/cppdb
git clone --depth 1 https://github.com/melpon/wandbox

mkdir cppcms_build
mkdir cppdb_build

# build cppcms

cd cppcms_build
cmake ../cppcms/ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/wandbox/kennel/cppcms -DDISABLE_SHARED=ON -DDISABLE_FCGI=ON -DDISABLE_SCGI=ON -DDISABLE_ICU_LOCALE=ON -DDISABLE_TCPCACHE=ON
make -j2
make install
cd ..

# build cppdb

cd cppdb_build
cmake ../cppdb/ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/wandbox/kennel/cppdb -DDISABLE_MYSQL=ON -DDISABLE_PQ=ON -DDISABLE_ODBC=ON
make
make install
cd ..

# build kennel
cd wandbox/kennel2
git submodule update -i
./autogen.sh
./configure --prefix=/opt/wandbox/kennel --with-cppcms=/opt/wandbox/kennel/cppcms --with-cppdb=/opt/wandbox/kennel/cppdb
make
make install
