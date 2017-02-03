#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <remote-host>"
  echo ""
  echo "example:"
  echo "  $0 username@example.com"
  echo "  $0 melpon-builder"
  exit 1
fi

set -ex

REMOTE_HOST=$1

scp wandbox/cattleshed-conf/compilers.default $REMOTE_HOST:/opt/wandbox/cattleshed-conf/
ssh $REMOTE_HOST service cattleshed restart
