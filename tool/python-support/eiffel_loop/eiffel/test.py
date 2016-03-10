#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 June 2010"
#	revision: "0.1"

import os, subprocess

from os import path
		
class TESTS (object):

# Initialization
	def __init__ (self, working_directory):
		self.working_directory = path.normpath (working_directory)
		self.test_args_sequence = []
		
# Element change

	def append (self, test_args):
		self.test_args_sequence.append (test_args)

# Basic operations

	def do_all (self, exe_path):
		previous_wd = os.getcwd ()
		command = path.join (previous_wd, exe_path)

		os.chdir (path.expandvars (self.working_directory))
		
		for test_args in self.test_args_sequence:
			ret_code = subprocess.call ([command] + test_args)
			if ret_code != 0:
				sys.stdout.write ('Execution failure\n')
				break
		
		os.chdir (previous_wd)
