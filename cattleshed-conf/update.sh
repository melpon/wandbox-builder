#!/bin/bash

# change owner to root
docker run --net=host -i -v `pwd`/..:/var/work -v `pwd`/../wandbox:/opt/wandbox melpon/wandbox:cattleshed-conf /bin/bash -c "
  cd /var/work/cattleshed-conf
  mkdir -p /opt/wandbox/cattleshed-conf
  python compilers.py > /opt/wandbox/cattleshed-conf/compilers.default
"
