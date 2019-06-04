#!/usr/bin/env bash
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/example/graphical/build/$ISE_PLATFORM/package/bin"
"$LD_LIBRARY_PATH/el_graphical" $*
