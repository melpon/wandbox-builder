#!/bin/bash

set -ex

function _vercmp() {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 2
        fi
    done
    return 0
}

function _compare_version() {
  case $2 in
    "==") _vercmp $1 $3; test $? -eq 0; return $?;;
    ">") _vercmp $1 $3; test $? -eq 1; return $?;;
    "<") _vercmp $1 $3; test $? -eq 2; return $?;;
    ">=") _vercmp $1 $3; test $? -eq 1 -o $? -eq 0; return $?;;
    "<=") _vercmp $1 $3; test $? -eq 2 -o $? -eq 0; return $?;;
    *) echo "$2 is not valid comparer"; exit 1;;
  esac
}

function compare_version() {
  { set +x; } 2>/dev/null
  _compare_version "$@"
  result=$?
  set -x
  { return $result; } 2>/dev/null
}

function wget_strict_sha256() {
  wget $1
  if sha256sum -c $2; then
    :
  else
    exit 1
  fi
}

function install_all() {
  version=$1
  cmd=$2
  cat $version | while read line; do
    if [ "$line" != "" ]; then
      $cmd $line < /dev/null
    fi
  done
}

function run_with_log() {
  shiftnum=$1
  shift 1
  command="$@"
  shift $shiftnum
  logname="$*"
  mkdir logs || true
  $command 2>&1 | tee "logs/$logname".log
  status=${PIPESTATUS[0]}
  echo "$*: $status" >> logs/result.log
}
BASE_DIR=$(cd $(dirname $0); pwd)
