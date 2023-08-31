#!/usr/bin/env bash
export LANG=en_GB.UTF-8
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/tool/eiffel/build/$ISE_PLATFORM/package/bin"

build/$ISE_PLATFORM/package/bin/el_eiffel -autotest $*

