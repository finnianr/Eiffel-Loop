#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "18 May 2009"
#	revision: "0.1"

# OBSOLETE MODULE

import os, string

from subprocess import call
from os import path

#Build an Eiffel project
def make_library (make_file_path):

	source_path = path.dirname (make_file_path)
	print source_path

	# Find the path to the library
	make_file = open (make_file_path, 'r')
	for line in make_file:
		if string.find (line, "OUT = ") != -1:
			lib_rel_path = string.split (line)[-1]
			break
	make_file.close
	lib_path = path.normpath (path.join (source_path, lib_rel_path))

	# Build it if it doesn't exist
	if path.exists (lib_path):
		print lib_path, 'exists'
	else:
		os.chdir (source_path)
		ret_code = call (['make'])

