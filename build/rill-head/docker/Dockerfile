ARG OCAML_VERSION="4.10.0"
ARG HOST_ARCH="x86_64"

######################################################################
#
FROM ubuntu:16.04 as llvm

ARG LLVM_VERSION="11.0.0"
ARG LLVM_CHECKSUM_SHA256="913f68c898dfb4a03b397c5e11c6a2f39d0f22ed7665c9cefa87a34423a72469"

#
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -qq -y \
    wget \
    cmake ninja-build gcc g++ python3 z3 git patch xz-utils \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /llvm-build
WORKDIR /llvm-build
RUN wget -q "https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz"
RUN echo "${LLVM_CHECKSUM_SHA256} *llvm-${LLVM_VERSION}.src.tar.xz" | sha256sum -c
RUN ls "llvm-${LLVM_VERSION}.src.tar.xz"
RUN file "llvm-${LLVM_VERSION}.src.tar.xz"
RUN tar Jxfv llvm-${LLVM_VERSION}.src.tar.xz

WORKDIR /llvm-build/llvm-${LLVM_VERSION}.src

ARG LLVM_PREFIX="/usr/local/llvm"
ARG LLVM_TARGETS_TO_BUILD="X86"
ARG LLVM_EXPERIMENTAL_TARGETS_TO_BUILD=""

RUN mkdir build
WORKDIR /llvm-build/llvm-${LLVM_VERSION}.src/build

RUN cmake -G 'Ninja' \
          -DCMAKE_INSTALL_PREFIX="${LLVM_PREFIX}" \
          -DCMAKE_BUILD_TYPE=Release \
          -DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS_TO_BUILD}" \
          -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${LLVM_EXPERIMENTAL_TARGETS_TO_BUILD}" \
          -DLLVM_ENABLE_TERMINFO=OFF \
          -DLLVM_ENABLE_ZLIB=OFF \
          -DLLVM_TOOLCHAIN_TOOLS="llvm-config" \
          -DLLVM_INCLUDE_UTILS=OFF \
          -DLLVM_INCLUDE_BENCHMARKS=OFF \
          -DLLVM_INCLUDE_EXAMPLES=OFF \
          -DLLVM_INCLUDE_TESTS=OFF \
          -DLLVM_INCLUDE_GO_TESTS=OFF \
          -DLLVM_INCLUDE_DOCS=OFF \
          ..

RUN ninja install

######################################################################
#
FROM ubuntu:16.04 as ocaml

ARG OPAM_VERSION="2.1.0-beta2"
ARG OPAM_CHECKSUM_SHA256="408eda4a2d364e7f0ee7137aed403df65471f981ec21bb909a6d82d508f07795"

ARG OCAML_VERSION
ARG HOST_ARCH

#
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        curl \
        cmake ninja-build gcc g++ python3 z3 m4 patch unzip && \
    rm -rf /var/lib/apt/lists/*

# opam
WORKDIR /tmp
RUN curl -sSfL "https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/opam-${OPAM_VERSION}-${HOST_ARCH}-linux" -o opam
RUN echo "${OPAM_CHECKSUM_SHA256} *opam" | sha256sum -c
RUN install opam /usr/local/bin/opam

# OCaml
WORKDIR /
ENV OPAMKEEPBUILDDIR false
ENV OPAMBUILDDOC false
ENV OPAMDOWNLOADJOBS 1
RUN opam init -y -a --disable-sandboxing --comp=${OCAML_VERSION}

######################################################################
#
FROM ubuntu:16.04

LABEL maintainer="yutopp <yutopp+wandbox-docker@gmail.com>"

ARG OCAML_VERSION

#
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
        curl \
        cmake ninja-build gcc g++ python3 z3 m4 patch unzip git pkgconf bzip2 xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Copy LLVM
COPY --from=llvm /usr/local/llvm/lib/* /usr/local/lib/
COPY --from=llvm /usr/local/llvm/include/* /usr/local/include/
COPY --from=llvm /usr/local/llvm/bin/llvm-config /usr/local/bin/.

# Copy opam
COPY --from=ocaml /usr/local/bin/opam /usr/local/bin/.

# Copy OCaml
RUN mkdir -p /root/.opam/
COPY --from=ocaml /root/.opam/config /root/.opam/config
COPY --from=ocaml /root/.opam/${OCAML_VERSION} /root/.opam/${OCAML_VERSION}
COPY --from=ocaml /root/.opam/opam-init /root/.opam/opam-init
COPY --from=ocaml /root/.opam/repo/repos-config /root/.opam/repo/repos-config
