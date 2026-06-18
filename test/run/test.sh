#!/usr/bin/env bash

export LANG=en_GB.UTF-8
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH=$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin

if [[ ! -f "$LD_LIBRARY_PATH/el_test" ]]; then
	export LD_LIBRARY_PATH=$EIFFEL_LOOP/test/build/linux-x86-64/EIFGENs/classic/F_code
fi

$LD_LIBRARY_PATH/el_test $*
