#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "13 July 2020"
#	revision: "0.2"

# Script to edit alternate implementation

import sys, os, platform

from os import path

def edit_file (file_path):
	command_table = {
		"Windows" : "C:/Program Files/gedit/bin/gedit.exe",
		"Linux" : "/usr/bin/gedit"
	}
	gedit_path = path.normpath (command_table [platform.system()])

	if path.exists (file_path):
		print "Editing", file_path
		os.spawnv (os.P_NOWAIT, gedit_path, [path.basename (gedit_path), file_path])
	else:
		print "path not found:", file_path

def open_directory (a_path):
	command_table = {
		"Windows" : "c:/Windows/explorer.exe",
		"Linux" : "/usr/bin/xdg-open"
	}
	if path.exists (a_path):
		cmd_path = path.normpath (command_table [platform.system()])
		os.spawnv (os.P_NOWAIT, cmd_path, [path.basename (cmd_path), a_path])
	else:
		print "path not found:", a_path

