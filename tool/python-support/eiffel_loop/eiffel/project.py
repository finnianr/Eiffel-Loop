#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 Jan 2010"
#	revision: "0.1"

import ctypes, os, string, sys, imp, platform

from string import Template
from os import path
from glob import glob
from distutils import dir_util

from eiffel_loop.eiffel.ecf import SYSTEM_INFO

from eiffel_loop.eiffel import ise
from eiffel_loop.xml.xpath import XPATH_ROOT_CONTEXT
from eiffel_loop.xml.xpath import XPATH_FRAGMENT_CONTEXT
from eiffel_loop.distutils import file_util
from eiffel_loop.scons.util import scons_command
from eiffel_loop import tar
from subprocess import call

global program_files

program_files = 'Program Files'

def platform_spec_build_dir ():
	return path.join ('spec', ise.platform)

def x86_path (a_path):
	result = a_path.replace (program_files, 'Program Files (x86)', 1)
	return result

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
			py_file.close ()
	else:
		print 'ERROR: find_module'
		result = None

	return result

def x86_environ (environ):
	result = {}
	x86_ise_platform = 'windows'

	# Change any /Program Files/ to /Program Files (x86)/
	for name in environ:
		l_dir = environ [name]
		if (l_dir).find (program_files) > 0:
			result [name] = x86_path (l_dir)
		else:
			result [name] = l_dir

	# Add a modified PATH for 32 bit EiffelStudio
	name = 'PATH'
	path_list = []
	for line in (os.environ [name]).split (';'):
		if line.startswith (ise.library):
			path_list.append (x86_path (line).replace ('win64', x86_ise_platform, 1))
		else:
			path_list.append (line)
	result [name] = (';').join (path_list)

	result ['ISE_LIBRARY'] = x86_path (ise.library)
	result ['ISE_EIFFEL'] = x86_path (ise.eiffel)
	result ['ISE_PLATFORM'] = x86_ise_platform

	return result

def create_gzipped_classic_f_code_tar (ise_platform):
	create_classic_f_code_tar (ise_platform)
	tar_path = path.join ('build', ('F_code-%s.tar') % ise_platform)
	print 'Compressing:', tar_path
	call (['gzip', tar_path])

def create_classic_f_code_tar (ise_platform):
	result = 'build/F_code-%s.tar' % ise_platform

	f_code_tar = tar.ARCHIVE (result)
	f_code_tar.chdir = 'build/%s' % ise_platform

	exclude_list = tar.wildcard_list (['exe', 'lib', 'o', 'obj'])
	exclude_list.extend (['*/finished'])

	print	'Creating:', result
	f_code_tar.append ('EIFGENs/classic/F_code', exclude_list)

	return path.normpath (result)

def restore_classic_f_code_tar (f_code_tar_path, ise_platform):
	build_dir = path.join ('build', ise_platform)
	windows_eifgens = path.join ('EIFGENs', build_dir)
	if path.exists (windows_eifgens):
		dir_util.remove_tree (windows_eifgens)
	
	print	'Extracting:', f_code_tar_path, ' to', build_dir
	call (['tar', '-xf', f_code_tar_path, '-C', build_dir])

def new_eiffel_project ():
	if os.name == "posix":
		result = UNIX_EIFFEL_PROJECT ()
	else:
		result = MSWIN_EIFFEL_PROJECT ()
	return result

def convert_pecf_to_xml (pecf_path):
	# Generate new ecf XML file
	result = call (['el_eiffel', '-pecf_to_xml', '-no_highlighting', '-in', pecf_path])
	if result > 0:
		print "Error converting %s to XML" % (pecf_path)
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
			call ([exe_path] + test_args)
#end class

# XML format ECF project file
class ECF_PROJECT_FILE (object):

# Constants
	Version_tag = '<version'

# Initialization

	def __init__ (self, name):
		self.name = name

# Basic operations

	def increment_build (self):
		f = open (self.name, 'r')
		lines = f.read ().split ('\n')
		f.close ()
		self.edit_version_line (lines)
		
		# Write the edits
		f = open (self.name, 'w')
		f.write ('\n'.join (lines))
		f.close ()

# Implementation

	def edit_version_line (self, lines):
		for i in range (0, len (lines) - 1):
			line = lines [i]
			if self.Version_tag in line:
				if '/>' in line:
					leading_space = line [0 : line.find (self.Version_tag)]
					root_ctx = XPATH_FRAGMENT_CONTEXT (line)
					version_ctx = root_ctx.context_list ('/version')[0]
					attribute_template = ' %s = "%s"'
					xml = leading_space + self.Version_tag
					for name, value in version_ctx.attrib_table ().items():
						if name == 'build':
							value = int (value) + 1
						xml += attribute_template % (name, value)
					lines [i] = xml + '/>'
					break
#end class

# Pyxis format ECF project file
class PYXIS_FORMAT_PROJECT_FILE (ECF_PROJECT_FILE):

# Basic operations
	def increment_build (self):
		ECF_PROJECT_FILE.increment_build (self)
		convert_pecf_to_xml (self.name)

# Implementation
	def edit_version_line (self, lines):
		for i in range (0, len (lines) - 1):
			line = lines [i]
			if 'major' in line and 'build' in line:
				# assumes build is at end of line
				pos_space = line.rfind (' ')
				lines [i] = line [:pos_space + 1] + str (int (line [pos_space + 1:]) + 1)
				break
#end class

class EIFFEL_PROJECT (object):

# Initialization
	def __init__ (self, ecf_name = None):
		if ecf_name:
			self.ecf_name = ecf_name
		else:
			self.ecf_name = glob ('*.ecf')[0]
		self.name = path.splitext (self.ecf_name)[0]
		self.pecf_name = self.name + '.pecf'
		
		system = SYSTEM_INFO (XPATH_ROOT_CONTEXT (self.ecf_name, 'ec'))

		self.exe_name = system.exe_name ()
		self.version = system.version ().short_string ()
# Access
	def eifgens_dir (self):
		result = path.join ('build', ise.platform, 'EIFGENs')
		return result

	def platform_name (self):
		pass

	def package_exe_path (self):
		# path to exe in package
		result =	exe_path = path.join ('build', ise.platform, 'package', 'bin', self.exe_name)
		return result

# Basic operation
	def autotest (self):
		# call -autotest option on finalized exe
		# returns 0 if no error
		exe_path = self.package_exe_path ()
		result = call ([exe_path, '-autotest'])
		return result

	def build (self, cpu_target, options_extra = None):
		options = ['cpu=' + cpu_target, 'action=finalize']
		if options_extra:
			options.extend (options_extra)
			
		call (scons_command (options))

	def clean_build (self):
		l_dir = self.eifgens_dir ()
		if path.exists (l_dir):
			dir_util.remove_tree (l_dir)

		f_code_tar = path.join ('build', 'F_code-%s.tar' % self.platform_name ()) 
		if path.exists (f_code_tar):
			os.remove (f_code_tar)

		self.freeze_build ()

	def freeze_build (self):
		# Build Workbench code
		call (scons_command (['action=freeze']))

	def copy (self, exe_path, exe_dest_path):
		pass

	def shared_object_list (self, dir_path):
		pass

	def link (self, target, link_name):
		pass

	def install (self, install_dir, f_code = False):
		# Install linked version of executable in `install_dir'
		if f_code:
			exe_path = path.join (self.eifgens_dir (), 'classic', 'F_code', self.exe_name)
		else:
			exe_path = self.package_exe_path ()

		exe_dest_path = path.join (install_dir, self.versioned_exe_name ())

		self.copy (exe_path, exe_dest_path)
		print "Copied " + exe_path + " to", install_dir

		if self.link (exe_dest_path, path.join (install_dir, self.exe_name)) == 0:
			print 'Linked', self.exe_name, '->', exe_dest_path
		else:
			print "Link error"

		for so_path in self.shared_object_list (path.dirname (exe_path)):
			dest_so_path = path.join (install_dir, path.basename (so_path))
			if not path.exists (dest_so_path):
				self.copy (so_path, dest_so_path)
				print 'Copied', so_path

	def increment_build_number (self):
		if path.exists (self.pecf_name):
			project = PYXIS_FORMAT_PROJECT_FILE (self.pecf_name)
		else:
			project = ECF_PROJECT_FILE (self.ecf_name)
		
		project.increment_build ()

# Implementation
	def versioned_exe_name (self):
		pass

#end class

class UNIX_EIFFEL_PROJECT (EIFFEL_PROJECT):

# Access
	def platform_name (self):
		return 'unix'

# Basic operation
	def copy (self, exe_path, exe_dest_path):
		return file_util.sudo_copy_file (exe_path, exe_dest_path)

	def shared_object_list (self, dir_path):
		return glob (path.join (dir_path, '*.so'))

	def link (self, target, link_name):
		return call (['sudo', 'ln', '-f', '-s', target, link_name])

# Implementation
	def versioned_exe_name (self):
		return self.exe_name + '-' + self.version


class MSWIN_EIFFEL_PROJECT (EIFFEL_PROJECT):
# Microsoft Windows project

# Access
	def platform_name (self):
		return 'windows'

# Basic operation
	def copy (self, exe_path, exe_dest_path):
		return file_util.copy_file (exe_path, exe_dest_path)

	def shared_object_list (self, dir_path):
		return glob (path.join (dir_path, '*.dll'))

	def link (self, target, link_name):
		if path.exists (link_name):
			os.remove (link_name)
		# need `shell = True' because `mklink' is built-in command
		return call (['mklink', link_name, target], shell = True)

# Implementation

	def versioned_exe_name (self):
		template = "%s" + '-' + self.version + "%s"
		return template % path.splitext (self.exe_name)

#end class
