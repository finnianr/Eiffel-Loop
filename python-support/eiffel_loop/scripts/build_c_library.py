#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 May 2026"
#	revision: "1.0"

# Builds C/C++ library with scons

# First sets up build environment before invoking scons

# Dir: Scripts

import codecs, importlib, os, subprocess, sys

from os import path
from argparse import ArgumentParser

from eiffel_loop.eiffel import project
from eiffel_loop.scons.util import scons_command
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE

def main ():
	os_is_windows = os.name == "nt"

	parser = ArgumentParser (usage = "build_c_library [--x86]")

	parser.add_argument (
		"-x", "--x86", action = "store_true", dest = "build_x86", default = False, help = "Build Windows 32 bit library"
	)
	parser.add_argument (
		"-c", "--clean", action = "store_true", dest = "clean_up", default = False,
		help = "Clean up C object files after compilation"
	)
	options = parser.parse_args()


	project_py = project.read_project_py ()

	if os_is_windows and options.build_x86:
		project_py.MSC_options [0] = '/x86'

	project.set_build_environment (project_py)
	project_py.print_environ ()

	config = EIFFEL_CONFIG_FILE (project_py.ecf)
	config.set_export_paths ()

	if subprocess.call (scons_command ()) == 0:
		if options.clean_up:
			subprocess.call (scons_command (['-c']))

if __name__ == '__main__':
	main()

