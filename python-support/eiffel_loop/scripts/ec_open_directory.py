#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 July 2020"
#	revision: "0.2"

import sys, os, platform
from eiffel_loop.os import file_system as _file

def main():
	if len (sys.argv) >= 2:
		dir_path = sys.argv [1]
	else:
		dir_path = None

	delete_count = int (sys.argv [2]) if len (sys.argv) == 3 else 0
	
	if delete_count in range (0, 4) and dir_path:
		
		steps = dir_path.split (os.sep) [:-delete_count]
		print ("Opening", dir_path)
		_file.open_directory (dir_path)
		print("DONE")
	else:
		print("USAGE: ec_open_directory <dir-path> <tail-delete-count>")

if __name__ == '__main__':
	main()


