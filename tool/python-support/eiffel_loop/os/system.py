#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "13 July 2020"
#	revision: "0.2"

# Script to edit alternate implementation

import sys, os, platform

from os import path

def launch_program (command_table, a_path):
	if path.exists (a_path):
		cmd_path = path.normpath (command_table [platform.system()])
		os.spawnv (os.P_NOWAITO, cmd_path, [path.basename (cmd_path), a_path])
	else:
		print "Executable path not found:", a_path

def edit_file (file_path):
	command_table = {
		"Windows" : "C:/Program Files/gedit/bin/gedit.exe",
		"Linux" : "/usr/bin/gedit"
	}
	steps = file_path.split (os.sep)[-3:]
	print "Editing", os.sep.join (steps)
	launch_program (command_table, file_path)

def open_directory (dir_path):
	command_table = {
		"Windows" : "c:/Windows/explorer.exe",
		"Linux" : "/usr/bin/xdg-open"
	}
	launch_program (command_table, dir_path)

