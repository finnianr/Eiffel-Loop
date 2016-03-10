#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 Jan 2010"
#	revision: "0.1"

import os, string, sys, imp, subprocess

from string import Template
from os import path

global ascii_environ
ascii_environ = {}

def platform_spec_build_dir ():
	return path.join ('spec', os.environ ['ISE_PLATFORM'])

def set_build_environment (project_py):
	env = project_py.environ
	MSC_options = project_py.MSC_options

	print 'PROJECT ENVIRONMENT\n'
	env_copy = env.copy ()
	for var, dir_path in env.items ():
		del env_copy [var]
		expanded_path = Template (dir_path).safe_substitute (env_copy)
		env [var] = path.normpath (path.expandvars (expanded_path))
		env_copy [var] = dir_path
		
	for var, dir_path in env.items ():
		print var, '=', dir_path
		os.environ [var] = dir_path

	if sys.platform == 'win32':
		set_windows_build_environment (MSC_options)
		
	os.environ ['ISE_LIBRARY'] = os.environ ['ISE_EIFFEL']
		
	for name, value in os.environ.items ():
		ascii_environ [str (name)] = str (value)
	ascii_environ ['ascii'] = ''
	
def set_windows_build_environment (MSC_options):
	x86_option = '/x86'
	x64_option = '/x64'
	
	if 'cpu=x86' in sys.argv:
		if x64_option in MSC_options:
			i = MSC_options.index (x64_option)
			MSC_options [i] = x86_option
		else:
			MSC_options.append (x86_option) 

	set_msc_environment_cmd = ['set_msc_environment.bat']
	set_msc_environment_cmd.extend (MSC_options)

	# Retrieve variables set
	if subprocess.call (set_msc_environment_cmd) == 0:
		f = open (path.join (os.environ ['TEMP'], 'msc_environment.txt'), 'r')
		for line in f.readlines ():
			pos_equal = line.find ('=') 
			name = line [0:pos_equal]
			value = line [pos_equal + 1:-1]

			# This is causing a problem on Windows for user maeda
			name = name.encode ('ascii')
			value = value.encode ('ascii')
			#print name, '=', value
			if name.lower() == 'path':
				exec_path = value
				#if exec_path.find (os.environ ['ISE_EIFFEL']) == -1:
				os.environ ['Path'] = exec_path
				#for item in exec_path.split (os.pathsep):
				#	print item
			else:
				if not os.environ.has_key (name):
					os.environ [name] = value
		f.close ()

		# Switch Python and EiffelStudio paths to x86
		if os.environ ['TARGET_CPU'] == 'x86':
			os.environ ['ISE_PLATFORM'] = 'windows'
			old_ise_eiffel = os.environ ['ISE_EIFFEL']

			for name in ['ISE_EIFFEL', 'PYTHON_HOME']:
				program_files_path = os.environ [name]
				os.environ [name] = program_files_path.replace ('Files', 'Files (x86)', 1)

			new_path = ''
			for bin_path in os.environ.get ('Path').split (os.pathsep):
				if len (bin_path) > 0:
					if bin_path.startswith (old_ise_eiffel):
						if 'msys' in bin_path:
							new_path = new_path + ';' + path.expandvars (r'$ISE_EIFFEL\gcc\$ISE_PLATFORM\msys\1.0\bin')

						elif 'studio' in bin_path:
							new_path = new_path + ';' + path.expandvars (r'$ISE_EIFFEL\studio\spec\$ISE_PLATFORM\bin')
					elif len (new_path) > 0:
						new_path = new_path + ';' + bin_path
					else:
						new_path = bin_path
						
			os.environ ['Path'] = new_path
		
		
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
		
		
		

