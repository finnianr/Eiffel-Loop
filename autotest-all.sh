#!/usr/bin/env bash

# Build and autotest all projects

# Get sudo permission in advance for installing resources
sudo cat /etc/fstab > nul

for dir_path in \
	test \
	test/eiffel2java \
	tool/toolkit \
	tool/eiffel \
	example/manage-mp3; \
do
	pushd .
	cd $dir_path
	ec_autotest_build.py
	popd
done

