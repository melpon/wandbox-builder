# How to build compilers

This simple tutorial demonstrates how to build compilers using Wandbox-builder.

# Building a specific version of the compiler
Let's assume that you want to build a specific version of clang. Before you start build the compiler, you need to know available versions of clang. That can be obtained by:

```
$ cd wandbox-build/build/clang
$ cat VERSIONS
8.0.0
7.0.0
.
.
.
3.2
3.1
```

Now, if you want to build 7.0.0,  then  `$ ./install.sh 7.0.0` will automatically build clang 7.0.0 in `/opt/wandbox/clang-$VERSION`. 

# Building all available version of the compiler
It is tadious to build all compilers using the script above. Fortunately, there is a script to build all available versions of a specific compiler is available.

To build all clang compiler, simply you need to run:

```
$ cd /wandbox-builder/build
$ ./install-all.sh clang
```

Then, all built compilers are saved in `/opt/wandbox/clang-$VERSION`.

