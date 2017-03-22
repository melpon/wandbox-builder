# Wandbox Builder

Wandbox の各種コンパイラを生成するためのツール

## 用語

<dl>
  <dt>言語:</dt>
  <dd>プログラミング言語。C++, Python など</dd>

  <dt>コンパイラ:</dt>
  <dd>あるプログラミング言語の１つの実装。ここではコンパイルを必要としない言語も含める。gcc, clang, cpython, pypy など</dd>

  <dt>特定バージョンのコンパイラ:</dt>
  <dd>コンパイラの特定バージョンのこと。gcc-4.8.2, cpython-3.5.1 など</dd>
</dl>

## 成果物

Wandbox Builder で生成した各コンパイラは、全て `wandbox/` 以下のディレクトリに配置される。

## docker

Wandbox Builder では、コンパイラの生成、テストに docker を利用している。
そのため、ビルドのためにローカル環境に様々なツールをインストールする必要は無い。

Wandbox Builder では、基本的に `build` ディレクトリを `/var/work` に、`wandbox` ディレクトリを `/opt/wandbox` にマウントして利用する。

以下の説明では、docker 環境下で実行していることを分かりやすくするため、`[dockerのタグ名] $ コマンド` という様な記述にする。

## コンパイラの追加方法

大まかには以下の通り。

1. 環境構築
2. コンパイラの追加とテスト
3. 設定ファイル記述
4. 結合テスト

### 1. 環境構築

ローカル環境には git と docker を入れておくこと。

```
$ git clone https://github.com/melpon/wandbox-builder.git
```

```
$ cd wandbox-builder/build
$ ./docker-run.sh cattleshed
[cattleshed] $ ./install.sh
```

```
$ cd wandbox-builder/build
$ ./docker-run.sh kennel
[kennel] $ ./install.sh
```

### 2. コンパイラの追加とテスト

Wandbox Builder にコンパイラを追加するには、Docker 環境下でビルドし、その成果物を `/opt/wandbox` 以下に配置する必要がある。

名前の付け方や使い方にいくつかルールがあるので、それを守ること。

- `docker/Dockerfile`: コンパイラをビルドするための Docker 環境
- `resources/`: インストールやテストに必要な各種ファイルを置くディレクトリ。
- `install.sh`: コンパイラをビルドするための Docker 環境の中から実行するインストールスクリプト
  - 通常は引数としてバージョンを受け取り、その指定されたバージョンのコンパイラをインストールする
- `test.sh`: 疑似本番用の Docker 環境の中から実行するテスト用スクリプト
  - 通常は引数としてバージョンを受け取り、その指定されたバージョンのコンパイラを使ってテストを実行する
- `VERSIONS`: 複数バージョンのコンパイラをインストールする場合、このファイルにインストール可能なバージョンの一覧を記述する

`install.sh` や `test.sh` では、以下の要件を守る必要がある。

- 基本的に `install.sh` は、引数としてバージョン情報のみを受け取り、バージョン毎に変えたい処理があるなら bash の `if` や `switch` 構文を使って分岐すること。
- `wget` 等でネットワーク上から取得したバイナリは、可能な限りチェックサムの比較を行うこと。
  - 取得とチェックを同時に行う `wget_strict_sha256` 関数を `build/init.sh` に定義してあるので、それを使うと良い
  - sha256 の取得は `build/sha256-calc.sh` を使うと良い
- インストール先は `/opt/wandbox/<コンパイラ>-<バージョン>` にすること

#### 例: SBCL

ここでは、コンパイラを追加するための具体的な手順を説明する。
例として SBCL (Steel Bank Common Lisp) を追加する。

最終的な内容は [このコミット](https://github.com/melpon/wandbox-builder/commit/ca3260f3a262d5b7f845ebf20de3332899e7d745) だが、どのような手順でこの内容を記述したのかを書いていく。

まず、コンパイラのためのディレクトリを作る。

```
$ cd build
$ mkdir sbcl
```

コンパイラをビルドするための環境を Dockerfile に記述する。
Dockerfile は `sbcl/docker` ディレクトリに配置する。

```
FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

この時点では何のアプリケーションが必要なのか分からないため、最低限、SBCL をダウンロードするための wget (あるいは curl) だけ入れている。
この時点で入れるべきアプリケーションが分かるなら、それを記述しても構わない。

この Dockerfile のイメージを生成するには、`./docker-build.sh` コマンドを利用する。

```
$ cd build
$ ./docker-build.sh sbcl
```

この生成したイメージの環境に入るには `./docker-run.sh` コマンドを利用する。

```
$ cd build
$ ./docker-run.sh sbcl
```

sbcl 環境の中で、まずインストールまでの確認を行う。

```
[sbcl] $ cd ~/
[sbcl] $ wget https://downloads.sourceforge.net/project/sbcl/sbcl/1.3.15/sbcl-1.3.15-source.tar.bz2
[sbcl] $ tar xf sbcl-1.3.15-source.tar.bz2
[sbcl] tar (child): lbzip2: Cannot exec: No such file or directory
[sbcl] tar (child): Error is not recoverable: exiting now
[sbcl] tar: Child returned status 2
[sbcl] tar: Error is not recoverable: exiting now
```

この時点で .bz2 が展開できなくてエラーになっているため、`apt-get install` で `bzip2` をインストールする。
SBCLのドキュメントによると、SBCLをビルドするには、make, sbcl を入れておくべきだということが分かるので、それらもインストールする。
また、パッケージリストはローカルから消しているので `apt-get update` も実行する。

```
[sbcl] $ apt-get update
[sbcl] $ apt-get install -y bzip2 make sbcl
[sbcl] $ tar xf sbcl-1.3.15-source.tar.bz2
[sbcl] $ cd sbcl-1.3.15
[sbcl] $ INSTALL_ROOT=/opt/wandbox/sbcl-1.3.15 sh make.sh
```

ここでまたエラーが出ていて、更に gcc, time パッケージを入れておく必要があるということが分かったので、それらをインストールする。

```
[sbcl] $ apt-get install -y gcc time
[sbcl] $ sh make.sh
```

まだエラーが出ていて、sb-concurrency のテストに失敗していた。
調べてみると、タイムアウトまでの時間が短いせいでテストに失敗しているらしい。
そのため sb-concurrency のタイムアウトまでの時間を延ばすことにする。

```
[sbcl] $ sed -i 's/with-timeout 10/with-timeout 60/g' contrib/sb-concurrency/tests/test-frlock.lisp
[sbcl] $ INSTALL_ROOT=/opt/wandbox/sbcl-1.3.15 sh make.sh
```

これでビルドが通ったので、インストールする。

```
[sbcl] INSTALL_ROOT=/opt/wandbox/sbcl-1.3.15 sh install.sh
```

これで無事 sbcl のインストールができた。

次にコンパイラのテストを行う。

インストールしたコンパイラは「ビルド環境では動作するが、本番環境で動作しない」ということがよくある。
本番環境では、ビルド環境で使っていたパッケージが入っていないことがあるからである。

そこで、擬似的な本番環境を Docker で構築し、その環境下で動作することを確認する。
擬似的な本番環境（test-server）に入るには `build/docker-testrun.sh` を実行する。

```
$ cd build
$ ./docker-testrun.sh sbcl
[test-server] $ /opt/wandbox/sbcl-1.3.15/bin/sbcl --script /var/work/resources/test.lisp
[test-server] fatal error encountered in SBCL pid 10(tid 0x7fabe9222700):
[test-server] can't find core file at /usr/local/lib/sbcl//sbcl.core
```

案の定、動作しなかった。
調べてみると、`SBCL_HOME` 環境変数を指定しておかないといけないようだ。

```
[test-server] $ SBCL_HOME=/opt/wandbox/sbcl-1.3.15/lib/sbcl /opt/wandbox/sbcl-1.3.15/bin/sbcl --script /var/work/resources/test.lisp
hello
```

無事動いた。
つまり sbcl は、実行時に `SBCL_HOME` 環境変数を設定した上で動かす実行する必要がある。

Wandbox には、環境変数を設定する機能が無い。
そのため環境変数を設定して `sbcl` を実行するスクリプトを用意しておく。
Wandbox はこのスクリプトを実行することで、環境変数を付けて `sbcl` を実行できるようになる。

build/sbcl/resources/run-sbcl.sh.in:

```bash
#!/bin/bash

export SBCL_HOME=@prefix@/lib/sbcl
@prefix@/bin/sbcl "$@"
```

このスクリプトは、インストール時に `@prefix@` を適切に置換した上でインストール先に配置することにする。

これで一通り確認できたので、これらの処理を `docker/Dockerfile` や `install.sh`, `test.sh` に記述していく。
`apt-get install` で入れたパッケージは `docker/Dockerfile` に記述する。

docker/Dockerfile:

```docker
FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      bzip2 \
      gcc \
      make \
      patch \
      sbcl \
      time \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

`install.sh` には、リソースの取得とチェックサムの比較、パッチの実行、ビルドとインストール、上記 `run-sbcl.sh.in` スクリプトの置換と配置、クリーンアップを記述する。

```bash
#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/sbcl-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://downloads.sourceforge.net/project/sbcl/sbcl/$VERSION/sbcl-${VERSION}-source.tar.bz2 \
  $BASE_DIR/resources/sbcl-${VERSION}-source.tar.bz2.sha256

tar xf sbcl-${VERSION}-source.tar.bz2
cd sbcl-${VERSION}

# apply patches

sed -i 's/with-timeout 10/with-timeout 60/g' contrib/sb-concurrency/tests/test-frlock.lisp

# build

export INSTALL_ROOT="$PREFIX"

sh make.sh
sh install.sh

cp $BASE_DIR/resources/run-sbcl.sh.in $PREFIX/bin/run-sbcl.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-sbcl.sh
chmod +x $PREFIX/bin/run-sbcl.sh

rm -r ~/*
```

`test.sh` では、擬似的な本番環境で sbcl を実行し、意図した出力が得られるかを確認する。

```bash
#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/sbcl-$VERSION

test "`$PREFIX/bin/run-sbcl.sh --script $BASE_DIR/resources/test.lisp`" = "hello"
```

後は、これらのスクリプトが正しく動作するかを確認する。

```
$ cd build
$ ./docker-build.sh sbcl
$ ./docker-run.sh sbcl
[sbcl] $ ./install.sh 1.3.15
[sbcl] $ exit
$ ./docker-testrun.sh sbcl
[test-server] $ ./test.sh 1.3.15
[test-server] $ exit
```

これで sbcl のバージョン 1.3.15 のコンパイラが入った。
他のバージョン、例えば 1.2.16 を追加したい場合、同様に `./install.sh` と `./test.sh` を実行する。
ただし、`wget` で取得するバイナリが変わるため、それ用のチェックサムファイルを用意することを忘れてはいけない。

```
$ cd build
$ ./docker-run.sh sbcl
[sbcl] $ cd .. && ./sha256-calc.sh sbcl https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.16/sbcl-1.2.16-source.tar.bz2 && cd sbcl
[sbcl] $ ./install.sh 1.2.16
```

この時点でまたエラーが出た。
どうやら 1.2.16 では、ブートストラップ用の sbcl コンパイラのバージョンによっては sb-bsd-socket で問題が出るらしい。
以下のようなパッチファイルを作り、それを適用してからコンパイルするように書き換える。

resources/sb-bsd-sockets-1.2.16.patch:

```patch
# https://bugs.launchpad.net/sbcl/+bug/1596043
--- a/contrib/sb-bsd-sockets/tests.lisp	2017-03-20 09:13:10.837459900 +0000
+++ b/contrib/sb-bsd-sockets/tests.lisp	2017-03-20 09:13:36.209903467 +0000
@@ -41,6 +41,8 @@
   (handler-case (get-protocol-by-name "nonexistent-protocol")
     (unknown-protocol ()
       t)
+    (simple-error ()
+      t)
     (:no-error ()
       nil))
   t)
```

```bash:install.sh
...

if compare_version "$VERSION" "==" "1.2.16"; then
  patch -p1 < $BASE_DIR/resources/sb-bsd-sockets-1.2.16.patch
fi

...
```

```
$ cd build
$ ./docker-run.sh sbcl
[sbcl] $ ./install.sh 1.2.16
[sbcl] $ exit
$ ./docker-testrun.sh sbcl
[test-server] $ ./test.sh 1.2.16
[test-server] $ exit
```

これで 1.3.15 と 1.2.16 の 2 バージョンが追加できた。

更に sbcl の HEAD バージョンも用意することにする。

TODO: sbcl の HEAD バージョンを用意する

### 3. 設定ファイル記述

無事コンパイラをインストールできたら、次は Wandbox に組み込むための設定ファイルを記述する必要がある。
設定ファイルは `cattleshed-conf/compilers.py` にある。

TODO: 詳細を書く。でも多分他の設定を見れば大体分かるはず。

設定ファイルも `wandbox/` ディレクトリ以下に配置する必要がある。
ここに配置するには `cattleshed-conf/update.sh` スクリプトを利用する。

```bash
$ cd cattleshed-conf
$ ./update.sh
```

### 4. 結合テスト

最後に、擬似的な本番環境下で、Wandbox のプロセスを立ち上げた上でテストを行う。
`test/run.py` にテストを記述する。

TODO: 詳細を書く。でも多分他のテストを見れば大体分かるはず。

テストを書けたら `test/run-test.sh` を実行する。

```bash
$ cd test
$ ./run-test.sh 'sbcl-*'
```

ここでエラーが起きた場合は、2 か 3 のどちらかの問題なので、それを修正して再度実行する。

## ライセンス

Wandbox Builder にあるプログラムは全て Boost Software License 1.0 でライセンスされています。
