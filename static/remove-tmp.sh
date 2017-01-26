#!/bin/sh
find /tmp -maxdepth 1 -name 'tmp.*' -not -mtime -1 -exec rm -rf \{\} \;
find /tmp/wandbox -maxdepth 1 -name 'wandbox*' -not -mtime -1 -exec rm -rf \{\} \;
