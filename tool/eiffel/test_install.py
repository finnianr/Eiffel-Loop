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
	"-x", "--x86", action="store_true",
	dest = "build_x86", default = False, help = "Build a 32 bit version in addition to 64 bit"
)
parser.add_option (
	"-n", "--no_build", action="store_true", dest="no_build", default=False, help="Build without incrementing build number"
)
parser.add_option (
	"-i", "--install", action="store", dest="install_dir", default=None, help="Installation location"
)
(options, args) = parser.parse_args()

project = new_eiffel_project ()

project.install (options.install_dir)

