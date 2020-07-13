#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 July 2020"
#	revision: "0.2"

# Script to edit alternate implementation

import sys, os, platform

from eiffel_loop.eiffel.project import new_eiffel_project
from eiffel_loop.os import path
from eiffel_loop.os import system

if len (sys.argv) == 2:
	file_path = sys.argv [1]
else:
	file_path = None

if file_path:
	steps = file_path.split (os.sep)
	if os.name == 'nt':
		imp_current = 'imp_mswin'; imp_other = 'imp_unix'
	else:
		imp_current = 'imp_unix'; imp_other = 'imp_mswin'

	steps [steps.index (imp_current)] = imp_other

	file_path = os.sep.join (steps)

	system.edit_file (file_path)

else:
	print "USAGE: ec_gedit_project.py [ecf | pecf | versions]"

