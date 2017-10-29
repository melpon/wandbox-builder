FROM ubuntu:16.04

LABEL maintainer="yutopp <yutopp+wandbox-docker@gmail.com>"

ARG LLVM_VERSION=5.0.0
ARG OCAML_VERSION=4.04.2

RUN apt-get update && \
    apt-get install -qq -y \
      aspcud \
      cmake \
      curl \
      g++ \
      git \
      libffi-dev \
      m4 \
      ocaml \
      pkg-config \
      python \
      unzip \
      wget && \
    apt-get clean -qq -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /root && \
    wget http://www.llvm.org/releases/$LLVM_VERSION/llvm-$LLVM_VERSION.src.tar.xz && \
    echo "e35dcbae6084adcf4abb32514127c5eabd7d63b733852ccdb31e06f1373136da *llvm-$LLVM_VERSION.src.tar.xz" | sha256sum -c && \
    tar Jxfv llvm-$LLVM_VERSION.src.tar.xz && \
    rm llvm-$LLVM_VERSION.src.tar.xz && \
    cd llvm-$LLVM_VERSION.src && \
    mkdir build && \
    cd build && \
    cmake -G 'Unix Makefiles' \
          -DCMAKE_INSTALL_PREFIX=/opt/llvm \
          -DCMAKE_BUILD_TYPE=Release \
          -DLLVM_TARGETS_TO_BUILD="X86" \
          -DLLVM_TARGETS_WITH_JIT="X86" \
          -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" \
          -DLLVM_ENABLE_TERMINFO=OFF \
          -DLLVM_ENABLE_ZLIB=OFF \
          -DLLVM_BUILD_TOOLS=clang,llc \
          -DLLVM_INCLUDE_UTILS=OFF \
          -DLLVM_BUILD_UTILS=OFF \
          -DLLVM_INCLUDE_EXAMPLES=OFF \
          -DLLVM_INCLUDE_TESTS=OFF \
          -DLLVM_INCLUDE_GO_TESTS=OFF \
          -DLLVM_INCLUDE_DOCS=OFF \
          -DLLVM_BUILD_DOCS=OFF \
          .. && \
    cmake --build . --target package/fast -- -j2 && \
    cmake --build . --target llc/fast -- -j2 && \
    cmake --build . --target llvm-config/fast -- -j2 && \
    cmake --build . --target install && \
    cp bin/llvm-config /opt/llvm/bin/. && \
    cp bin/llc /opt/llvm/bin/. && \
    rm -r /root/llvm-$LLVM_VERSION.src
ENV PATH=/opt/llvm/bin:$PATH

COPY patches /patches
RUN wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin && \
    OPAMKEEPBUILDDIR=false && \
    OPAMBUILDDOC=false && \
    OPAMDOWNLOADJOBS=1 \
    opam init -y -a --comp=$OCAML_VERSION && \
    opam install \
      batteries \
      bisect_ppx \
      ctypes-foreign \
      loga \
      menhir \
      ocamlgraph \
      ocveralls \
      omake.0.10.2 \
      ounit \
      stdint && \
    # BEGIN: adhoc for WebAssembly
    opam install llvm.$LLVM_VERSION --deps-only && \
    mkdir opam_source && \
    cd opam_source && \
    opam source llvm.$LLVM_VERSION && \
    cd llvm.$LLVM_VERSION && \
    # patch install.sh /patches/opam_llvm.5.0.0_install.sh.patch && \
    # patch opam /patches/opam_llvm.5.0.0_opam.patch && \
    opam pin add llvm-custom . --kind=path && \
    # END: adhoc for WebAssembly
    cp ~/.opam/$OCAML_VERSION/lib/llvm/static/*.cmxa ~/.opam/$OCAML_VERSION/lib/llvm/. && \
    rm ~/.opam/archives/* && \
    rm ~/.opam/repo/default/archives/* && \
    rm ~/.opam/$OCAML_VERSION/bin/*.byte && \
    rm -r ~/.opam/repo/default/packages/* && \
    rm -r ~/.opam/repo/default/compilers/*
