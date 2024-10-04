#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    unzip
  exit 0
fi

# get sources

VERSION_SHORT=`echo $VERSION | cut -d'.' -f1,2`

curl_strict_sha256 \
  http://caml.inria.fr/pub/distrib/ocaml-$VERSION_SHORT/ocaml-$VERSION.tar.gz \
  $BASE_DIR/resources/ocaml-$VERSION.tar.gz.sha256

tar xf ocaml-$VERSION.tar.gz

pushd ocaml-$VERSION
  # build
  ./configure -prefix $PREFIX
  make -j`nproc` world.opt
  make install

  export PATH=$PREFIX/bin:$PATH
  export OPAMROOT=$PREFIX/.opam

  # install opam
  echo "" | bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"

  opam init --disable-sandboxing < /dev/null
  opam switch create ocaml-system
  opam install -y ocamlfind

  # janestreet core
  opam install -y core
popd

# ocaml settings
cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
