# Wandbox Builder

A tool to build each compilers for Wandbox.

[日本語ドキュメントはこちら](./README.jp.md)

## Terminology

<dl>
  <dt>Language:</dt>
  <dd>Programming language (e.g. C++, Python, ...)</dd>

  <dt>Compiler:</dt>
  <dd>One of implementations for a programming language. Languages which does not need compiler are contained here (e.g. gcc, clang, cpython, pypy, ...)</dd>

  <dt>Specific version compiler:</dt>
  <dd>Specific version of compiler (e.g. gcc-4.8.2, cpython-3.5.1)</dd>
</dl>

## Artifacts

All compilers built by Wandbox Builder are put under the directory `wandbox/`.

## docker

Wandbox Builder uses docker for building and testing compilers.
You don't need to install various tools to your local environment for building them.

Wandbox Builder basically mounts `build` directory onto `/var/work` and mounts `wandbox` directory onto `/opt/wandbox`.

In following explanation, we use `[docker tag name] $ command` format to describe that it is executed under the docker container.

## How to add a new compiler

Briefly described as below:

1. Make an environment
2. Add a compiler and its tests
3. Write a config file
4. Integration tests

### 1. Make an Environment

Please install git and docker in your local environment in advance.

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

### 2. Add a Compiler and Its Tests

To add a new compiler to Wandbox Builder, it needs to be built in Docker environment and built artifacts should be put in `/opt/wandbox`.

There is some naming rules. Please follow them.

- `docker/Dockerfile`: Docker environment to build the compiler
- `resources/`: A directory for putting some files required for installing and testing the compiler
- `install.sh`: Installation script executed in docker environment for building the compiler
  - Normally it receives version name by program argument and installs the specified version compiler
- `test.sh`: Test script executed in staging docker environment.
  - Normally it receives version name by program argument and runs tests using the specified version compiler
- `VERSIONS`: When installing multiple different version compilers, describe the list of available versions to this file.

`install.sh` and `test.sh` MUST meet below requirements.

- Basically `install.sh` only receives version name. If there are version-dependant processes, please use `if` or `switch` statements in the script.
- Binaries which was acquired from network (e.g. `wget`) should be validated with checksum as much as possible.
  - `build/init.sh` defines `wget_strict_sha256` function which acquires and validates checksum at the same time. It would help you.
  - `build/sha256-calc.sh` is available to obtain sha256 hash.
- You MUST install the compiler into `/opt/wandbox/<compiler>-<version>`.

#### Example: SBCL

In this section, I explain how to add a new compiler in practice.
For example, let's say to add SBCL (Steel Bank Common Lisp).

Eventually it will be [this commit](https://github.com/melpon/wandbox-builder/commit/ca3260f3a262d5b7f845ebf20de3332899e7d745).

At first, make a directory for it.

```
$ cd build
$ mkdir sbcl
```

Describe an environment to build the compiler to Dockerfile.
It is put in `sbcl/docker`.

```
FROM ubuntu:16.04

MAINTAINER melpon <shigemasa7watanabe+docker@gmail.com>

RUN apt-get update && \
    apt-get install -y \
      wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

In this point, I install only wget (or curl), which is used for downloading SBCL because I don't know what is required to install SBCL actually.
If you already know what should be installed at this point, you can write them to the Dockerfile here.

To make an image of the Dockerfile, use `./docker-build.sh` command.

```
$ cd build
$ ./docker-build.sh sbcl
```

To enter the generated image, use `./docker-run.sh` command.

```
$ cd build
$ ./docker-run.sh sbcl
```

In sbcl environment, confirm the installation.

```
[sbcl] $ cd ~/
[sbcl] $ wget https://downloads.sourceforge.net/project/sbcl/sbcl/1.3.15/sbcl-1.3.15-source.tar.bz2
[sbcl] $ tar xf sbcl-1.3.15-source.tar.bz2
[sbcl] tar (child): lbzip2: Cannot exec: No such file or directory
[sbcl] tar (child): Error is not recoverable: exiting now
[sbcl] tar: Child returned status 2
[sbcl] tar: Error is not recoverable: exiting now
```

From the log, it fails because it could not unarchive .bz2 file. So install `bzip2` with `apt-get install`.
Referring to SBCL documentation, make and sbcl should be installed to build SBCL.
`apt-get update` is needed because packages list are removed from the local environment.

Then try again.

```
[sbcl] $ apt-get update
[sbcl] $ apt-get install -y bzip2 make sbcl
[sbcl] $ tar xf sbcl-1.3.15-source.tar.bz2
[sbcl] $ cd sbcl-1.3.15
[sbcl] $ INSTALL_ROOT=/opt/wandbox/sbcl-1.3.15 sh make.sh
```

It fails again. It looks that it requires gcc and time pacakges. Install them.

Then try again.

```
[sbcl] $ apt-get install -y gcc time
[sbcl] $ sh make.sh
```

It still fails. Tests for sb-concurrency failed.
After some investigation, it failed because timeout is too short.
Increase the timeout parameter.

```
[sbcl] $ sed -i 's/with-timeout 10/with-timeout 60/g' contrib/sb-concurrency/tests/test-frlock.lisp
[sbcl] $ INSTALL_ROOT=/opt/wandbox/sbcl-1.3.15 sh make.sh
```

Finally build succeeded. Let's install the built artifacts.

```
[sbcl] INSTALL_ROOT=/opt/wandbox/sbcl-1.3.15 sh install.sh
```

I could install sbcl.

Next, add tests for the built compiler.
it often occurs that it works fine on built environment but it doesn't on production environment.
In production environment, there may not be some packages which is used on build environment.

So make a staging environment and check the built compiler works fine on the environment.
To enter the staging environment, run `build/docker-testrun.sh`.

```
$ cd build
$ ./docker-testrun.sh sbcl
[test-server] $ /opt/wandbox/sbcl-1.3.15/bin/sbcl --script /var/work/resources/test.lisp
[test-server] fatal error encountered in SBCL pid 10(tid 0x7fabe9222700):
[test-server] can't find core file at /usr/local/lib/sbcl//sbcl.core
```

It did not work fine.
Some investigation says that `SBCL_HOME` environment variable is required.

```
[test-server] $ SBCL_HOME=/opt/wandbox/sbcl-1.3.15/lib/sbcl /opt/wandbox/sbcl-1.3.15/bin/sbcl --script /var/work/resources/test.lisp
hello
```

It worked fine.
So sbcl requires that `SBCL_HOME` environment variable is set at runtime.

Wandbox has not a feature to specify environments.
Thus, prepare a script to set the environment variable and execute `sbcl`.
Wandbox run this script.

build/sbcl/resources/run-sbcl.sh.in:

```bash
#!/bin/bash

export SBCL_HOME=@prefix@/lib/sbcl
@prefix@/bin/sbcl "$@"
```

This script will be put in the installation directory after replacing `@prefix@` properly.

Entire process was confirmed. Describe it to `docker/Dockerfile`, `install.sh` and `test.sh`.
Packages which is installed with `apt-get install` should be described in `docker/Dockerfile`.

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

Describe acquiring resources, validating checksum, applying patches, building, installing, putting `run-sbcl.sh.in` script with the above replacement and cleaning up to `install.sh`.


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

if compare_version "$VERSION" "==" "1.2.16"; then
  patch -p1 < $BASE_DIR/resources/sb-bsd-sockets-1.2.16.patch
fi

# build

export INSTALL_ROOT="$PREFIX"

sh make.sh
sh install.sh

cp $BASE_DIR/resources/run-sbcl.sh.in $PREFIX/bin/run-sbcl.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-sbcl.sh
chmod +x $PREFIX/bin/run-sbcl.sh

rm -r ~/*
```

In `test.sh`, execute sbcl on staging environment and check the output is intended.

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

Confirm these scrips run correctly.

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

Finally sbcl version 1.3.15 was installed.
When installing other version, for example 1.2.16, execute `./install.sh` and `./test.sh` the same as above.
Please do not forget preparing a checksum file because binaries acquired with `wget` are different from ones for 1.3.15.

```
$ cd build
$ ./docker-run.sh sbcl
[sbcl] $ cd .. && ./sha256-calc.sh sbcl https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.16/sbcl-1.2.16-source.tar.bz2 && cd sbcl
[sbcl] $ ./install.sh 1.2.16
```

At this point, an error occurred.
It seems that 1.2.16 causes a problem with some version of compiler for bootstrapping.
To fix this, make a patch file like below and change scripts to apply it before compiling SBCL.

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

install.sh:

```bash
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

Now two versions, 1.3.15 and 1.2.16, are available.

Additionally, let's say to prepare HEAD version of sbcl.

TODO: Prepare the HEAD version of sbcl and describe how to prepare it.

### 3. Write a Config File

Next, write a config file to integrate the built compiler into Wandbox.
The config file is put at `cattleshed-conf/compilers.py`.

TODO: Describe more details (although it's not hard to understand by looking configs for other languages)

The config file must be put in `wandbox/` directory also.
To put it in the directory, `cattleshed-conf/update.sh` script is available.

```bash
$ cd cattleshed-conf
$ ./update.sh
```

### 4. Integration Tests

At last, run a test with running Wandbox process on staging environment.
Describe the test in `test/run.py`.

TODO: Describe more details (although it's not hard to understand by looking configs for other languages)

After writing the test, run `test/run-test.sh`.

```bash
$ cd test
$ ./run-test.sh 'sbcl-*'
```

If some error occurs in this phase, there should be some problems in 2. section or 3. section. Please fix them and try again.

