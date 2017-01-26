#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)/build
cd $BASE_DIR

for compiler in \
    gcc-head \
    clang-head \
    mono-head \
    boost-head \
; do
  if [ "$compiler" = "boost-head" ]; then
    cat $compiler/VERSIONS | while read line; do
      if [ "$line" != "" ]; then
        COMMAND="cd /var/work/$compiler && ./install.sh $line"
        docker run --net=host -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:$compiler /bin/bash -c "$COMMAND"
      fi
    done
  else
    COMMAND="cd /var/work/$compiler && exec ./install.sh"
    docker run --net=host -v $BASE_DIR:/var/work -v $BASE_DIR/../wandbox:/opt/wandbox melpon/wandbox:$compiler /bin/bash -c "$COMMAND"
  fi
done

./docker-rm.sh
./sync.sh cattleshed-root
