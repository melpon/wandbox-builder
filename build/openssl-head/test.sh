#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/openssl-head

test "`$PREFIX/bin/with-env.sh openssl genrsa 1024 | head -n 1`" = "-----BEGIN RSA PRIVATE KEY-----"
