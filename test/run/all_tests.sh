#!/usr/bin/env bash
export LANG=en_GB.UTF-8
export EIFFEL_LOOP=$EIFFEL/library/Eiffel-Loop
export LD_LIBRARY_PATH="$EIFFEL_LOOP/test/build/$ISE_PLATFORM/package/bin"

do_test=build/$ISE_PLATFORM/package/bin/el_test

# Do first to give time for socket address to be released for -eros_autotest
$do_test -simple_client_server_test

$do_test -amazon_instant_access_autotest

$do_test -base_autotest
$do_test -base_autotest -single -zstring_codec ISO-8859-1

# compression.ecf
$do_test -compression_autotest

# encryption.ecf
$do_test -encryption_autotest

# http-client.ecf
$do_test -http_client_autotest

$do_test -image_utils_autotest

# i18n.ecf
$do_test -i18n_autotest

# multi-media.ecf
$do_test -multimedia_autotest

# os-command.ecf
$do_test -os_command_autotest

# xdoc-scanning.ecf
$do_test -xdoc_scanning_autotest

# markup-docs.ecf
$do_test -open_office_autotest
$do_test -thunderbird_autotest

# paypal-SBM.ecf
$do_test -paypal_standard_button_manager_autotest

# search-engine.ecf
$do_test -search_engine_autotest

# TagLib.ecf
$do_test -taglib_autotest

$do_test -vtd_xml_autotest

$do_test -eros_autotest


