#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "12 Feb 2019"
#	revision: "0.01"

#	Description: build finalized Eiffel-Loop project and call -autotest option

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

usage = "usage: ec_build_finalized [--x86]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-x", "--x86", action = "store_true",
	dest = "build_x86", default = False, help = "Build a 32 bit version in addition to 64 bit"
)
(options, args) = parser.parse_args()

if options.build_x86:
	architecture = 'x86'
else:
	architecture = 'x64'
	
# Find project ECF file
project = new_eiffel_project ()

project.increment_build_number ()

project.build (architecture)

import eiffel_loop.scripts.ec_install_resources

os.environ ['LANG'] = 'en_US.UTF-8'
project.autotest ()

