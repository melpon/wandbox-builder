FROM melpon/wandbox:clang

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      clang-8  \
      curl \
      git \
      libssl-dev \
      zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /root/.pyenv/bin:$PATH
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    echo "eval $(pyenv init -)" >> ~/.bashrc && \
    echo "eval $(pyenv virtualenv-init -)" >> ~/.bashrc && \
    pyenv install 3.8.6 && \
    pyenv global 3.8.6

ENV CMAKE_VERSION="3.16.3" \
    CMAKE_SHA256="3e15dadfec8d54eda39c2f266fc1e571c1b88bf32f9d221c8a039b07234206fa"

ENV CMAKE_PREFIX="/usr/local/wandbox/camke-${CMAKE_VERSION}"

RUN cd ~/ && \
    wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    echo "${CMAKE_SHA256} *cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" | sha256sum -c && \
    tar xf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    mkdir -p /usr/local/wandbox/ && \
    mv cmake-${CMAKE_VERSION}-Linux-x86_64 $CMAKE_PREFIX
