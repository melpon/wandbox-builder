#!/bin/sh
EXEC="exec "

if test x"$1" = x--debug; then
   DEBUG=--debug
   shift
fi

if test x"$1" = x--gdb; then
   shift
   EXEC="gdb --eval-command=run --args "
fi

if test x"$1" = x--valgrind; then
  shift
  EXEC="valgrind $VALGRIND_OPTIONS"
fi

$EXEC @MONO_PREFIX@/bin/mono $DEBUG $MONO_OPTIONS @FSC_PATH@ --exename:$(basename "$0") "$@"
