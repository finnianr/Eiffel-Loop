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
from subprocess import Popen, DEVNULL

# Class definitions

class FILE_SYSTEM:

# Constants
	Windows_imp_list = ['imp_mswin', 'mswin']
	
	Unix_imp_list = ['imp_unix', 'gtk']

# Initialization
	def __init__ (self, sudo = False):
		self.sudo = sudo
		
# Access
	
	def other_os_imp (self, file_path):
		# if `file_path' has an OS specific step, result is path to the other OS implementation
		# Example: "C/imp_unix/el_c_wide_character_string.e" -> "C/imp_mswin/el_c_wide_character_string.e"
		
		steps = file_path.split (os.sep)

		for imp_current in self.imp_list_current:
			if imp_current in steps:
				imp_other = self.imp_list_other [self.imp_list_current.index (imp_current)]
				steps [steps.index (imp_current)] = imp_other
				break

		return os.sep.join (steps)

# Basic operations
	def edit (self, file_path):
		steps = file_path.split (os.sep)[-3:]
		print("Editing:", os.sep.join (steps))

	def copy_tree (self, src_path, dest_path):
		pass

	def move_tree (self, src_path, dest_path):
		pass

	def copy_file (self, src_path, dest_path):
		pass

	def open_directory (self, dir_path):
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
		
	def _launch_program (self, cmd_path, a_path):
		if path.exists (cmd_path):
			pid = Popen ([cmd_path, a_path], stdout=DEVNULL, stderr=DEVNULL)
		else:
			raise FileNotFoundError ("Executable not found: " + cmd_path)

# end class
		
class WINDOWS_FILE_SYSTEM (FILE_SYSTEM):

# Initialization
	def __init__ (self, sudo = False):
		super ().__init__ (sudo)
		self.imp_list_current = self.Windows_imp_list
		self.imp_list_other = self.Unix_imp_list

# Basic operations

	def copy_tree (self, src_path, dest_path):
		# /Q Does not display file names while copying.
		self.execute (['xcopy', '/Q', '/S', '/I', src_path, dest_path])

	def edit (self, file_path):
		super ().edit (file_path)
		self._launch_program (r"C:\Program Files\gedit\bin\gedit.exe", file_path)

	def move_tree (self, src_path, dest_path):
		self.execute (['move', src_path, dest_path])

	def copy_file (self, src_path, dest_path):
		self.execute (['copy', src_path, dest_path])

	def open_directory (self, dir_path):
		self._launch_program (r"C:\Windows\explorer.exe", dir_path)

	def remove_tree (self, dir_path):
		self.execute (['rmdir', '/S', '/Q', dir_path])

# Implementation

	def execute (self, cmd):
		osprocess.call (cmd, shell = True)

# end class

class POSIX_FILE_SYSTEM (FILE_SYSTEM):

# Initialization
	def __init__ (self, sudo = False):
		super ().__init__ (sudo)
		self.imp_list_current = self.Unix_imp_list
		self.imp_list_other = self.Windows_imp_list

# Basic operations

	def copy_tree (self, src_path, dest_path):
		self.execute (['cp', '-r', src_path, dest_path])

	def edit (self, file_path):
		super ().edit (file_path)
		self._launch_program ("/usr/bin/gedit", file_path)

	def move_tree (self, src_path, dest_path):
		self.execute (['mv', src_path, dest_path])

	def copy_file (self, src_path, dest_path):
		self.execute (['cp', src_path, dest_path])

	def open_directory (self, dir_path):
		self._launch_program ("/usr/bin/nautilus", dir_path)

	def remove_tree (self, dir_path):
		self.execute (['rm', '-r', dir_path])

# Implementation

	def execute (self, cmd):
		if self.sudo:
			osprocess.sudo_call (cmd)		
		else:
			osprocess.call (cmd)

# end class
