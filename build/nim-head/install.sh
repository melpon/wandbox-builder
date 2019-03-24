#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/nim-head

cd ~/

# Download nightly rather than source with git clone.
# Because nightles are posted only when it passes all testing.
curl -s https://api.github.com/repos/nim-lang/nightlies/releases | \
  grep -m 1 "\"browser_download_url\": \"https://github.com/nim-lang/nightlies/releases/download/\(.*\W\)\?devel\W.*-linux_x64\.tar\.xz\"" | \
  sed -E 's/.*"browser_download_url\": \"([^"]+)\"/\1/' | \
  wget -qi - -O nim.tar.xz
tar xf nim.tar.xz
cd nim*
# bootstraps Nim compiler and compiles tools
sh build.sh
bin/nim c koch
./koch tools

# install
sh install.sh ~/tmp
[ -e "$PREFIX" ] && rm -r "$PREFIX"
mv ~/tmp/nim "$PREFIX"
