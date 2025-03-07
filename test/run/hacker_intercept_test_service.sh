#!/usr/bin/env bash

export LANG=en_GB.UTF-8
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin"

if [[ ! $1 ]]
then
	echo Usage: run/hacker_intercept_test_service.sh \"\<server-prefix\>\"
	return
fi

$LD_LIBRARY_PATH/el_test -hacker_intercept_test_service -logging \
	-config "$HOME/.config/Hex 11 Software/$1-server/hacker_intercept_service/config.pyx"
