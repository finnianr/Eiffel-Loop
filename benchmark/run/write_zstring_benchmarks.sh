#!/usr/bin/env bash
export LANG=en_GB.UTF-8
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop

do_benchmark=build/$ISE_PLATFORM/package/bin/el_benchmark

destination=$HOME/www/eiffel-loop.com/benchmark

$do_benchmark -zstring_benchmark -zstring_codec ISO-8859-1 -runs 50 -output $destination
$do_benchmark -zstring_benchmark -zstring_codec ISO-8859-15 -runs 50 -output $destination

echo Output in\: $destination
ls -l $destination


