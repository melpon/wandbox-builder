#!/bin/bash

. ./init.sh

set -e
set +x

rm logs/result.log || true
install_all VERSIONS install_if_not_exists
