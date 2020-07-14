#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 July 2020"
#	revision: "0.2"

import sys, os, platform

from eiffel_loop.os import system

if len (sys.argv) >= 2:
	dir_path = sys.argv [1]
else:
	dir_path = None

if len (sys.argv) == 3:
	delete_count = int (sys.argv [2])
else:
	delete_count = 0

if delete_count in range (0, 4) and dir_path:
	steps = dir_path.split (os.sep) [:-delete_count]
	system.open_directory (os.sep.join (steps))
	print "DONE"; exit (0)
else:
	print "USAGE: ec_open_directory <dir-path> <tail-delete-count>"


