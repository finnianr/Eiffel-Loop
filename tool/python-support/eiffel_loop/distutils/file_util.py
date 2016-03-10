#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "2 June 2010"
#	revision: "0.1"

import platform, string, fnmatch, os, sys

from distutils.file_util import *

from eiffel_loop import osprocess

global is_windows

def quoted (str):
	return '"%s"' % str

is_windows = sys.platform == 'win32'

# Directory operations requiring root or administrator permissions

def sudo_copy_file (src_path, dest_path):
	print 'from', src_path
	print 'to', dest_path
	if is_windows:
		copy_file (src_path, dest_path)
		# Won't work if '+' in path
		# osprocess.call (['copy', '/Y', src_path, dest_path], shell = True)
	else:
		osprocess.sudo_call (['cp', src_path, dest_path])
		
def delete_files (dir_path, filter):
	for root, dirnames, filenames in os.walk(dir_path):
		for filename in fnmatch.filter(filenames, filter):
			os.remove (os.path.join(root, filename))
		

def read_file_integer (file_path):
	f = open (file_path, 'r')
	result = int (f.readline ())
	f.close ()
	return result;
