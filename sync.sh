#!/bin/bash

if [ $# -lt 2 ]; then
  echo "$0 <remote-host> [--all] [compiler1 [compiler2 [...]]]"
  echo ""
  echo "example:"
  echo "  $0 username@example.com --all"
  echo "  $0 melpon-builder --all"
  echo "  $0 melpon-builder 'gcc-head'"
  echo "  $0 melpon-builder 'elixir-*' 'erlang-*'"
  exit 1
fi

set -ex

BASE_DIR=$(cd $(dirname $0); pwd)
REMOTE_HOST=$1
shift 1

function has_all() {
  for arg in "$@"; do
    if [ "$arg" = "--all" ]; then
      return 0
    fi
  done
  return 1
}

if has_all "$@"; then
  rsync -a --delete -v $BASE_DIR/wandbox $REMOTE_HOST:/opt/
else
  cd $BASE_DIR/wandbox
  rsync -a --delete -v `echo $@` $REMOTE_HOST:/opt/wandbox
fi

ssh $REMOTE_HOST setcap cap_sys_admin,cap_sys_chroot,cap_mknod,cap_net_admin=p /opt/wandbox/cattleshed/bin/cattlegrid
