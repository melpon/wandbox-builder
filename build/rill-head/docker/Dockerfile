FROM ubuntu:16.04

MAINTAINER yutopp <yutopp+wandbox-docker@gmail.com>

RUN apt-get update && \
    apt-get install -qq -y git curl wget unzip ocaml g++ aspcud cmake python m4 pkg-config libffi-dev && \
    apt-get clean -qq -y && \
    rm -rf /var/lib/apt/lists/*

COPY llvm-3.9.1.src.tar.xz.sha256 root/.
RUN cd /root && \
    wget http://www.llvm.org/releases/3.9.1/llvm-3.9.1.src.tar.xz && \
    cat llvm-3.9.1.src.tar.xz.sha256 | sha256sum -c && \
    tar Jxfv llvm-3.9.1.src.tar.xz && \
    rm llvm-3.9.1.src.tar.xz && \
    cd llvm-3.9.1.src && \
    mkdir build && \
    cd build && \
    cmake -G 'Unix Makefiles' \
          -DCMAKE_INSTALL_PREFIX=/opt/llvm \
          -DCMAKE_BUILD_TYPE=Release \
          -DLLVM_TARGETS_TO_BUILD="X86" \
          -DLLVM_BUILD_TOOLS=OFF \
          -DLLVM_INCLUDE_EXAMPLES=OFF \
          -DLLVM_INCLUDE_TESTS=OFF \
          ..
RUN cd /root/llvm-3.9.1.src/build && \
    cmake --build . --target package/fast -- -j2 && \
    cmake --build . --target llc/fast -- -j2 && \
    cmake --build . --target llvm-config/fast -- -j2
RUN cd /root/llvm-3.9.1.src/build && \
    cmake --build . --target install && \
    cp bin/llvm-config /opt/llvm/bin/. && \
    cp bin/llc /opt/llvm/bin/.

RUN wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
RUN opam init -y -a
RUN opam switch 4.04.0

RUN OPAMDOWNLOADJOBS=1 opam install omake.0.9.8.6-0.rc1 menhir batteries ctypes \
                                    ctypes-foreign stdint ocamlgraph ounit
RUN OPAMDOWNLOADJOBS=1 \
    PATH=$PATH:/opt/llvm/bin \
    LIBRARY_PATH=$LIBRARY_PATH:/opt/llvm/lib \
    opam install -y llvm.3.9
