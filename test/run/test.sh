#!/usr/bin/env bash
export LD_LIBRARY_PATH=$PWD/build/$ISE_PLATFORM/package/bin
$LD_LIBRARY_PATH/el_test $*
