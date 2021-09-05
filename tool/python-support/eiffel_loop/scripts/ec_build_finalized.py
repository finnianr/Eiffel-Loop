#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "12 Feb 2019"
#	revision: "0.01"

#	Description: build finalized Eiffel-Loop project and optionally install it

import os, sys, codecs

from os import path
from subprocess import call
from optparse import OptionParser

from eiffel_loop.eiffel.project import new_eiffel_project

# Word around for bug "LookupError: unknown encoding: cp65001"
if os.name == "nt":
	platform_name = "windows"
	codecs.register (lambda name: codecs.lookup ('utf-8') if name == 'cp65001' else None)
else:
	platform_name = "unix"

usage = "usage: ec_build_finalized [--x86] [--install] [--no_build]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-x", "--x86", action = "store_true",
	dest = "build_x86", default = False, help = "Build a 32 bit version in addition to 64 bit"
)
parser.add_option (
	"-n", "--no_build", action = "store_true", dest = "no_build", default = False, help = "Build without incrementing build number"
)
parser.add_option (
	"-i", "--install", action = "store", dest = "install_dir", type = "string", default = "", help = "Installation location"
)
parser.add_option (
	"-a", "--autotest", action = "store_true", dest = "autotest", default = False, help = "Test before installing"
)
(options, args) = parser.parse_args()

target_architectures = ['x64']

if options.build_x86:
	target_architectures.append ('x86')
	
# Find project ECF file
project = new_eiffel_project ()

f_code_tar = path.join ('build', 'F_code-%s.tar') % platform_name
if not path.exists (f_code_tar):
	f_code_tar = None

# Update project.py build_number for `build_info.e'
if options.no_build:
	if f_code_tar:
		os.remove (f_code_tar)
else:
	project.increment_build_number ()
	# remove if corrupted (size is less than 1 mb)
	if f_code_tar:
		if os.path.getsize(f_code_tar) < 1000000:
			os.remove (f_code_tar)

for cpu_target in target_architectures:
	project.build (cpu_target)

if options.autotest:
	import eiffel_loop.scripts.install_resources
	passed_tests = project.autotest () == 0
else:
	passed_tests = True

# Install with version link
if passed_tests and options.install_dir:
	project.install (options.install_dir)

