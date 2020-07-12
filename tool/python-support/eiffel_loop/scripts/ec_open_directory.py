#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 July 2020"
#	revision: "0.2"

import sys, os, platform

from os import path

def open_directory (a_path):
	command_table = {
		"Windows" : "c:/Windows/explorer.exe",
		"Linux" : "/usr/bin/xdg-open"
	}
	cmd_path = path.normpath (command_table [platform.system()])
	os.spawnv (os.P_NOWAIT, cmd_path, [path.basename (cmd_path), a_path])

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
	open_directory (os.sep.join (steps)) 
else:
	print "USAGE: ec_open_directory <dir-path> <tail-delete-count>"

