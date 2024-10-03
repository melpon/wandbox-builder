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

  # install opam
  curl -fLO https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh
  sh opam_installer.sh $PREFIX/bin

  export PATH=$PREFIX/bin:$PATH
  export OPAMROOT=$PREFIX/.opam
  opam init < /dev/null

  # ocamlfind
  function install_ocaml_find_by_source {
    git clone --depth 1 https://github.com/ocaml/ocamlfind.git
    pushd ocamlfind
      ./configure -bindir $PREFIX/bin
      make -j`nproc` all
      make install
    popd
  }

  opam install -y ocamlfind || install_ocaml_find_by_source

  # Jane Street Core を入れようとしたけど、
  # うまくいかないので今はコメントアウトしておく
  ## janestreet core
  #opam install -y core
popd

# ocaml settings
cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
