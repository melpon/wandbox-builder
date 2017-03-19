#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ruby-head

#!/bin/bash

test "`$PREFIX/bin/ruby $BASE_DIR/resources/test.rb`" = "hello"
