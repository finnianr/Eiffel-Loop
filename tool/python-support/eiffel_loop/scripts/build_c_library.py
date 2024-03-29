#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "30 July 2019"
#	revision: "0.1"

# Builds C/C++ library with scons

# First sets up build environment before invoking scons

# Dir: Scripts

import codecs, importlib, os, subprocess, sys

from os import path
from optparse import OptionParser

from eiffel_loop.eiffel import project
from eiffel_loop.scons.util import scons_command

if os.name == "nt":
	codecs.register (lambda name: codecs.lookup ('utf-8') if name == 'cp65001' else None)
	is_windows_platform = True
else:
	is_windows_platform = False

usage = "Usage: build_c_library.py [--x86]"
parser = OptionParser (usage=usage)
parser.add_option (
	"-x", "--x86", action="store_true", dest = "build_x86", default = False, help = "Build Windows 32 bit library"
)
parser.add_option (
	"-c", "--clean", action="store_true", dest = "clean_up", default = False,
	help = "Clean up C object files after compilation"
)
(options, args) = parser.parse_args()

config = importlib.import_module ("eiffel_loop.eiffel.dev_environ")

if is_windows_platform and options.build_x86:
	config.MSC_options [0] = '/x86'

project.set_build_environment (config)
# config.print_environ ()

if subprocess.call (scons_command ()) == 0:
	if options.clean_up:
		subprocess.call (scons_command (['-c']))
	

