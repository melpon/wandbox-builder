#!/bin/bash

scp wandbox/cattleshed-conf/compilers.default cattleshed-root:/opt/wandbox/cattleshed-conf/
ssh cattleshed-root service cattleshed restart
