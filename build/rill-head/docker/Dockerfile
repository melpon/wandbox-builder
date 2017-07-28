FROM ubuntu:16.04

MAINTAINER yutopp <yutopp+wandbox-docker@gmail.com>

RUN apt-get update && \
    apt-get install -qq -y git curl wget unzip ocaml g++ aspcud cmake python m4 pkg-config libffi-dev && \
    apt-get clean -qq -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /root && \
    wget http://www.llvm.org/releases/4.0.1/llvm-4.0.1.src.tar.xz && \
    echo "da783db1f82d516791179fe103c71706046561f7972b18f0049242dee6712b51 *llvm-4.0.1.src.tar.xz" | sha256sum -c && \
    tar Jxfv llvm-4.0.1.src.tar.xz && \
    rm llvm-4.0.1.src.tar.xz && \
    cd llvm-4.0.1.src && \
    mkdir build && \
    cd build && \
    cmake -G 'Unix Makefiles' \
          -DCMAKE_INSTALL_PREFIX=/opt/llvm \
          -DCMAKE_BUILD_TYPE=Release \
          -DLLVM_TARGETS_TO_BUILD="X86" \
          -DLLVM_BUILD_TOOLS=OFF \
          -DLLVM_INCLUDE_EXAMPLES=OFF \
          -DLLVM_INCLUDE_TESTS=OFF \
          .. && \
    cmake --build . --target package/fast -- -j2 && \
    cmake --build . --target llc/fast -- -j2 && \
    cmake --build . --target llvm-config/fast -- -j2 && \
    cmake --build . --target install && \
    cp bin/llvm-config /opt/llvm/bin/. && \
    cp bin/llc /opt/llvm/bin/. && \
    rm -r /root/llvm-4.0.1.src

RUN wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin && \
    opam init -y -a && \
    opam switch 4.04.0 && \
    OPAMDOWNLOADJOBS=1 \
        opam install -y \
            omake.0.10.2 \
            menhir \
            batteries \
            ctypes \
            ctypes-foreign \
            stdint \
            ocamlgraph \
            ounit && \
    OPAMDOWNLOADJOBS=1 PATH=$PATH:/opt/llvm/bin LIBRARY_PATH=$LIBRARY_PATH:/opt/llvm/lib \
        opam install -y llvm.4.0.0 && \
    cp ~/.opam/4.04.0/lib/llvm/static/*.cmxa ~/.opam/4.04.0/lib/llvm/.
