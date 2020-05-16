#!/usr/bin/env bash
export LANG=en_GB.UTF-8
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin"

do_test=build/$ISE_PLATFORM/package/bin/el_test

$do_test -zstring_benchmark -zstring_codec ISO-8859-15 -runs 30 -output $HOME/dev/web-sites/eiffel-loop.com/benchmark
$do_test -zstring_benchmark -zstring_codec ISO-8859-1 -runs 30 -output $HOME/dev/web-sites/eiffel-loop.com/benchmark

