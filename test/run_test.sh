#!/usr/bin/env bash
export EIFFEL_LOOP=/home/finnian/dev/Eiffel/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL/Eiffel-Loop/test/package/$ISE_PLATFORM/bin"
"$LD_LIBRARY_PATH/el_test" $*
