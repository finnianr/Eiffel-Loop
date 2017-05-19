#!/usr/bin/env bash
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin"
"$LD_LIBRARY_PATH/el_test" $*
