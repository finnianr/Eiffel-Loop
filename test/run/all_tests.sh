#!/usr/bin/env bash
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin"

do_test=build/$ISE_PLATFORM/package/bin/el_test

# Do first to give time for socket address to be released for -eros_autotest
$do_test -simple_client_server_test

$do_test -amazon_instant_access_autotest

$do_test -base_autotest

$do_test -encryption_autotest

$do_test -bex_builder_test

$do_test -object_builder

$do_test -xdoc_scanning_autotest

$do_test -eros_autotest


