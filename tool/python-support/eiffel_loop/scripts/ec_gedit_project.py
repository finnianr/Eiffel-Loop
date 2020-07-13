#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 July 2020"
#	revision: "0.2"

import sys, os, platform

from eiffel_loop.eiffel.project import new_eiffel_project
from eiffel_loop.os import path
from eiffel_loop.os import system

if len (sys.argv) == 2:
	extension = sys.argv [1]
else:
	extension = 'ecf'

if extension in ['ecf', 'pecf']:

	# Find project ECF file
	project = new_eiffel_project ()
	if extension == 'ecf':
		file_path = path.join (path.curdir (), project.ecf_name)
	else:
		file_path = path.join (path.curdir (), project.pecf_name)

	system.edit_file (file_path)

elif extension == 'txt':
	system.edit_file (path.join (path.curdir (), 'doc', 'versions.txt'))

else:
	print "USAGE: ec_gedit_project.py [ecf | pecf | versions]"

