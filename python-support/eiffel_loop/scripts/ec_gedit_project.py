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
from eiffel_loop.os import file_system as _file

def main():
	if len (sys.argv) == 2:
		extension = sys.argv [1]
	else:
		extension = 'ecf'

	if extension in ['ecf', 'pecf']:
		project = new_eiffel_project ()
		if extension == 'ecf':
			file_path = path.join (path.curdir (), project.ecf_name)
		else:
			file_path = path.join (path.curdir (), project.pecf_name)
		
		_file.edit (file_path)
		print("DONE"); exit (0)

	elif extension == 'txt':
		_file.edit (path.join (path.curdir (), 'doc', 'versions.txt'))
		print("DONE"); exit (0)

	else:
		print("USAGE: ec_gedit_project [ecf | pecf | versions]")

if __name__ == '__main__':
	main()

