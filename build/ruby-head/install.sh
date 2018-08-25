#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ruby-head
BOOTSTRAP_RUBY_VERSION=2.5.0

export PATH=/opt/wandbox/ruby-$BOOTSTRAP_RUBY_VERSION/bin:$PATH

# get sources

cd ~/
git clone --depth 1 https://github.com/ruby/ruby.git
cd ruby

# apply the patch for https://bugs.ruby-lang.org/issues/14747
sed -i -e s#require\ \'rubygems/errors\'#require\ \'rubygems/errors\'\\nrequire\ \'rubygems/path_support\'# lib/rubygems.rb

# build

autoconf
./configure --disable-install-rdoc --disable-install-doc --prefix=$PREFIX
make -j2
make update-gems
make extract-gems
make install

rm -r ~/*
