#!/usr/bin/env bash
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin"

# Do first to give time for socket address to be released for -eros_autotest
"$LD_LIBRARY_PATH/el_test" -simple_client_server_test

# Need to find problem with AIA_VERIFIER
"$LD_LIBRARY_PATH/el_test" -amazon_instant_access_autotest

"$LD_LIBRARY_PATH/el_test" -bex_builder_test

"$LD_LIBRARY_PATH/el_test" -object_builder

"$LD_LIBRARY_PATH/el_test" -eros_autotest


