#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 Jan 2010"
#	revision: "0.1"

import os, string, sys, imp, subprocess

from string import Template
from os import path
from glob import glob

from eiffel_loop.xml.xpath import XPATH_CONTEXT
from subprocess import call

global program_files

program_files = 'Program Files'

def platform_spec_build_dir ():
	return path.join ('spec', os.environ ['ISE_PLATFORM'])

def x86_path (a_path):
	return a_path.replace (program_files, 'Program Files (x86)', 1)

def read_project_py ():
	py_file, file_path, description = imp.find_module ('project', [path.abspath (os.curdir)])
	if py_file:
		try:
			result = imp.load_module ('project', py_file, file_path, description)
			print 'Read project.py'
		except (ImportError), e:
			print 'Import_module exception:', e
			result = None
		finally:
			py_file.close
	else:
		print 'ERROR: find_module'
		result = None

	return result

def x86_environ (environ):
	result = {}
	x86_ise_platform = 'windows'
	ise_library = os.environ ['ISE_LIBRARY']

	path_list = []

	for name in environ:
		l_dir = environ [name]
		if (l_dir).find (program_files) > 0:
			result [name] = x86_path (l_dir)

	for name in ['Path', 'PYTHONPATH']:
		for line in (os.environ [name]).split (';'):
			if line.startswith (ise_library):
				path_list.append (x86_path (line).replace ('win64', x86_ise_platform, 1))
			else:
				path_list.append (line)
		result [name] = (';').join (path_list)

	result ['ISE_LIBRARY'] = x86_path (ise_library)
	result ['ISE_EIFFEL'] = x86_path (os.environ ['ISE_EIFFEL'])
	result ['ISE_PLATFORM'] = x86_ise_platform

	return result

def create_gzipped_classic_f_code_tar (ise_platform):
	create_classic_f_code_tar (ise_platform)
	tar_path = path.join ('build', ('F_code-%s.tar') % ise_platform)
	print 'Compressing:', tar_path
	call (['gzip', tar_path])

def create_classic_f_code_tar (ise_platform):
	build = 'build'
	result = path.join (build, ('F_code-%s.tar') % ise_platform)

	exclusions = path.join (build, 'exclude.txt')

	f = open (exclusions, 'w')
	for ext in ['lib', 'obj', 'exe']:
		f.write ('*.%s\n' % ext)
	f.write (r'*\finished')
	f.close ()
	f_code_dir = path.join ('EIFGENs', 'classic', 'F_code')

	print	'Creating:', result
	call (['tar', '-cf', result, '-X', exclusions, '-C', path.join ('build', ise_platform), f_code_dir ])
	os.remove (exclusions)
	return result
	
def restore_classic_f_code_tar (f_code_tar_path, ise_platform):
	build_dir = path.join ('build', ise_platform)
	windows_eifgens = path.join ('EIFGENs', build_dir)
	if path.exists (windows_eifgens):
		dir_util.remove_tree (windows_eifgens)
	
	print	'Extracting:', f_code_tar_path, ' to', build_dir
	call (['tar', '-xf', f_code_tar_path, '-C', build_dir])

class TESTS (object):

# Initialization
	def __init__ (self, working_directory):
		self.working_directory = path.normpath (working_directory)
		self.test_sequence = []
		
# Element change

	def append (self, test_args):
		self.test_args_sequence.append (test_args)

# Basic operations

	def do_all (self, exe_path):
		os.chdir (path.expandvars (self.working_directory))
		for test_args in test_args_sequence:
			subprocess.call ([exe_path] + test_args)
		
		
class EIFFEL_PROJECT (object):

# Initialization
	def __init__ (self):
		# Get version from Eiffel class BUILD_INFO in source
		f = open (path.normpath ('source/build_info.e'), 'r')
		for ln in f.readlines ():
			if ln.startswith ('\tVersion_number'):
				numbers = ln [ln.rfind (' ') + 1:-1].split ('_')
				break
		f.close ()
		for i, n in enumerate (numbers):
			numbers [i] = str (int (n))
		self.version = ('.').join (numbers)

		project_name = glob ('*.ecf')[0]
		self.exe_name = XPATH_CONTEXT (project_name, 'ec').attribute ('/ec:system/@name')

# Basic operation
	def install (self, install_dir, f_code = False):
		# Install linked version of executable in `install_dir'
		platform = os.environ ['ISE_PLATFORM']
		if f_code:
			exe_path = path.join ('build', platform, 'EIFGENs', 'classic', 'F_code', self.exe_name)
		else:
			exe_path = path.join ('build', platform, 'package', 'bin', self.exe_name)

		exe_dest_path = path.join (install_dir, self.exe_name + '-' + self.version)

		if subprocess.call (['sudo', 'cp', '-T', exe_path, exe_dest_path]) == 0:
			print "Copied " + exe_path + " to", install_dir
		else:
			print "Copy error"

		if subprocess.call (['sudo', 'ln', '-f', '-s', exe_dest_path, path.join (install_dir, self.exe_name)]) == 0:
			print 'Linked', self.exe_name, '->', exe_dest_path
		else:
			print "Link error"

