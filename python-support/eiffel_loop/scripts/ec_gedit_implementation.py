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
from eiffel_loop.os import file_system as _file

def main():
	if len (sys.argv) == 2:
		file_path = sys.argv [1]
	else:
		file_path = None

	if file_path:
		other_path = _file.other_os_imp (file_path)
		if path.exists (other_path):
			_file.edit (other_path)
		else:
			raise FileNotFoundError ("Other implementation: " + other_path)
			
		print("DONE"); exit (0)

	else:
		print("USAGE: ec_gedit_implementation <$file_name>")

if __name__ == '__main__':
	main()

