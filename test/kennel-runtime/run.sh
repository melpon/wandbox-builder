#!/bin/bash

set -ex
IP=`/usr/bin/getent ahostsv4 cattleshed-runtime | cut -d' ' -f1 | sort -u`
cp /opt/wandbox/kennel/etc/kennel.json /tmp/kennel.json
sed "s/\"host\" : \".*\"/\"host\" : \"$IP\"/" -i /tmp/kennel.json
sed "s/\"api\" : \"http\"/\"api\" : \"http\", \"ip\" : \"0.0.0.0\"/" -i /tmp/kennel.json
exec /opt/wandbox/kennel/bin/kennel \
       -c /tmp/kennel.json
