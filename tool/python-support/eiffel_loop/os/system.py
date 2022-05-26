#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "13 July 2020"
#	revision: "0.2"

# Script to edit alternate implementation

import sys, os, platform

from os import path
from eiffel_loop import osprocess

def launch_program (command_table, a_path):
	if path.exists (a_path):
		cmd_path = command_table [platform.system()]
		os.spawnv (os.P_NOWAIT, path.normpath (cmd_path), [path.basename (cmd_path), a_path])
		if os.name == 'posix':
			os.wait ()
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
		"Linux" : "/usr/bin/nautilus"
	}
	launch_program (command_table, dir_path)

def new_file_system (sudo = False):
	if platform.system () == 'Windows':
		result = WINDOWS_FILE_SYSTEM (sudo)
	else:
		result = UNIX_FILE_SYSTEM (sudo)

	return result

class FILE_SYSTEM (object):

# Initialization
	def __init__ (self, sudo = False):
		self.sudo = sudo

# Basic operations

	def copy_tree (self, src_path, dest_path):
		pass

	def move_tree (self, src_path, dest_path):
		pass

	def copy_file (self, src_path, dest_path):
		pass

	def remove_tree (self, dir_path):
		pass

	def make_path (self, dir_path):
		parent_path = path.dirname (dir_path)
		if not path.exists (parent_path):
			self.make_path (parent_path)

		self.execute (['mkdir', dir_path])

# Implementation

	def execute (self, cmd):
		pass

# end class
		
class WINDOWS_FILE_SYSTEM (FILE_SYSTEM):

# Basic operations

	def copy_tree (self, src_path, dest_path):
		# /Q Does not display file names while copying.
		self.execute (['xcopy', '/Q', '/S', '/I', src_path, dest_path])

	def move_tree (self, src_path, dest_path):
		self.execute (['move', src_path, dest_path])

	def copy_file (self, src_path, dest_path):
		self.execute (['copy', src_path, dest_path])

	def remove_tree (self, dir_path):
		self.execute (['rmdir', '/S', '/Q', dir_path])

# Implementation

	def execute (self, cmd):
		osprocess.call (cmd, shell = True)

# end class

class UNIX_FILE_SYSTEM (FILE_SYSTEM):

# Basic operations

	def copy_tree (self, src_path, dest_path):
		self.execute (['cp', '-r', src_path, dest_path])

	def move_tree (self, src_path, dest_path):
		self.execute (['mv', src_path, dest_path])

	def copy_file (self, src_path, dest_path):
		self.execute (['cp', src_path, dest_path])

	def remove_tree (self, dir_path):
		self.execute (['rm', '-r', dir_path])

# Implementation

	def execute (self, cmd):
		if self.sudo:
			osprocess.sudo_call (cmd)		
		else:
			osprocess.call (cmd)

# end class
