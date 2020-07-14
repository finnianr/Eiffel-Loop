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
	Windows_imp_list = ['imp_mswin', 'mswin']
	Unix_imp_list = ['imp_unix', 'gtk']
	

	steps = file_path.split (os.sep)
	if os.name == 'nt':
		imp_list_current = Windows_imp_list; imp_list_other = Unix_imp_list
	else:
		imp_list_current = Unix_imp_list; imp_list_other = Windows_imp_list

	for imp_current in imp_list_current:
		if imp_current in steps:
			imp_other = imp_list_other [imp_list_current.index (imp_current)]
			steps [steps.index (imp_current)] = imp_other
			break

	file_path = os.sep.join (steps)

	system.edit_file (file_path)
	print "DONE"; exit (0)

else:
	print "USAGE: ec_gedit_implementation.py <$file_name>"

