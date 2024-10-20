#!/bin/bash

set -e

if [ -z "$1" ]; then
  YEARMONTH=`date --date='1 month ago' '+%Y%m'`
else
  YEARMONTH=$1
fi

cd /opt/wandbox/_log

export HOME=/root
export PATH=/usr/local/bin:$PATH
echo `aws --version`
echo "YEARMONTH=$YEARMONTH"
echo "Run after 10 seconds..."

sleep 10

set -x

tar -zcf ran${YEARMONTH}.tar.gz ran/${YEARMONTH}*/
aws s3 cp ran${YEARMONTH}.tar.gz s3://wandbox-log/

echo "Waiting..."
sleep 60

rm ran${YEARMONTH}.tar.gz
rm -rf ran/${YEARMONTH}*/