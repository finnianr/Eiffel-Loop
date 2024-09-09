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
	# obsolete: use eiffel_loop.os.system.new_file_system ()
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
		
def find_files (directory, pattern):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if fnmatch.fnmatch(basename, pattern):
                filename = os.path.join(root, basename)
                yield filename

def read_file_integer (file_path):
	f = open (file_path, 'r')
	result = int (f.readline ())
	f.close ()
	return result;

def match_count (file_path, is_match):
	# return dictionary of values read from file
	result = 0
	f = open (file_path, 'r')
	for line in f:
		if is_match (line):
			result = result + 1
		
	f.close ()
	return result;

def read_table (file_path):
	# return dictionary of values read from file
	result = {}
	collect_lines = False
	f = open (file_path, 'r')
	for line in f:
		if collect_lines and len (line) > 0 and line [0] == '\t':
			value = line.strip ()
			if value:
				result.get (name).append (value)
			else:
				collect_lines = False

		else:
			pos_colon = line.find (':')
			if pos_colon > 0 and line [0] != '#':
				name = line [:pos_colon]
				value = (line [(pos_colon + 1):]).strip ()
				if value:
					result [name] = value
				else:
					result [name] = []
					collect_lines = True
		
	f.close ()
	return result;

