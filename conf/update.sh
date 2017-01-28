#!/bin/bash

python compilers.py > ../wandbox/conf/compilers.default

# change owner to root
docker run --net=host -i -v `pwd`/../wandbox:/opt/wandbox ubuntu:16.04 /bin/bash -c "
  set -ex
  chown -R root:root /opt/wandbox/conf/compilers.default
"
