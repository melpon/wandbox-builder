FROM ubuntu:16.04

MAINTAINER yutopp <yutopp+wandbox-docker@gmail.com>

RUN apt-get update && \
    apt-get install -qq -y git curl wget unzip ocaml g++ aspcud cmake python m4 pkg-config libffi-dev && \
    apt-get clean -qq -y && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
RUN opam init -y -a
RUN opam switch 4.04.0

RUN OPAMDOWNLOADJOBS=1 opam install omake.0.9.8.6-0.rc1 menhir batteries ctypes \
                                    ctypes-foreign stdint ocamlgraph ounit
