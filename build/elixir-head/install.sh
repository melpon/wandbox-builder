#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/elixir-head
VERSION=head
ERLANG_VERSION=head

cd ~/

git clone --depth 1 https://github.com/elixir-lang/elixir.git

export PATH=/opt/wandbox/erlang-$ERLANG_VERSION/bin:$PATH

cd elixir
export PREFIX
make
make install
cd ..

rm -rf elixir

cp $BASE_DIR/resources/run-elixir.sh.in $PREFIX/bin/run-elixir.sh
chmod +x $PREFIX/bin/run-elixir.sh
sed -i "s/@erlang_version@/$ERLANG_VERSION/g" $PREFIX/bin/run-elixir.sh
sed -i "s/@version@/$VERSION/g" $PREFIX/bin/run-elixir.sh
