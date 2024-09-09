#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "27 Nov 2016"
#	revision: "0.1"

from __future__ import absolute_import

import os, sys

from os import path
from subprocess import call

# USE ONLY UNIX STYLE PATHS EVEN ON WINDOWS

def wildcard_list (ext_list):
	result = []
	for ext in ext_list:
		result.append ('*.' + ext)
	return result

def prefixed_list (prefix, path_list):
	result = []
	for p in path_list:
		result.append (prefix + '/' + p)
	return result

# creates TAR object using tar command and Unix style paths  
# Windows tar.exe command found in mingw also uses Unix style paths

class ARCHIVE (object):

# Initialization
	def __init__ (self, file_path):
		self.file_path = file_path
		self.verbose = False
		self.chdir = None
	
# Basic operations

	def append (self, dir_path, exclusion_list = None):
		exclude_path = self.file_path + '.exclude'
		cmd = ['tar']
		if self.verbose:
			cmd.append ('--verbose')
		if path.exists (self.file_path):
			cmd.append ('-rf')
		else:
			cmd.append ('-cf')

		cmd.append (self.file_path)

		if exclusion_list:
			f = open (exclude_path, 'w')
			for exclusion in exclusion_list:
				f.write (exclusion + '\n')
			f.close ()
			cmd.extend (['-X', exclude_path])

		if self.chdir:
			cmd.extend (['-C', self.chdir])

		cmd.append (dir_path)
		print cmd
		call (cmd)

		if exclusion_list:
			os.remove (exclude_path)

	def extract (self):
		cmd = ['tar', 'xf']
		if self.verbose:
			cmd.append ('--verbose')
		cmd.append (self.file_path)

		if self.chdir:
			cmd.extend (['-C', self.chdir])
		print cmd
		call (cmd)
		

# Implementation


