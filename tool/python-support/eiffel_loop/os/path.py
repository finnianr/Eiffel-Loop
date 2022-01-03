#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 Jan 2010"
#	revision: "0.1"

import os
from os.path import *

global program_files

program_files = 'Program Files'

def files_x86 (a_path):
	if program_files in a_path:
		result = a_path.replace (program_files, 'Program Files (x86)', 1)
	else:
		result = a_path
	return result

def curdir ():
	result = abspath (os.curdir)
	return result

def curdir_up_to (step):
	result = curdir ()
	if step in result.split (os.sep):
		while basename (result) != step:
			result = dirname (result)
	return result

def as_ecf (a_path):
	parts = splitext (a_path)
	if parts [1] == '.pecf':
		result = parts [0] + '.ecf'
	else:
		result = a_path
	return result

def as_pecf (a_path):
	parts = splitext (a_path)
	if parts [1] == '.ecf':
		result = parts [0] + '.pecf'
	else:
		result = a_path

	return result

