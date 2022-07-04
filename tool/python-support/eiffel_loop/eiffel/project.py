#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 Jan 2010"
#	revision: "0.1"

import ctypes, os, string, sys, imp, platform, stat

from string import Template
from eiffel_loop.os import path
from glob import glob
from distutils import dir_util

from eiffel_loop.eiffel.ecf import SYSTEM_INFO

from eiffel_loop.C_util import C_dev
from eiffel_loop.os import environ

from eiffel_loop.eiffel import ise_environ
from eiffel_loop.xml.xpath import XPATH_ROOT_CONTEXT
from eiffel_loop.xml.xpath import XPATH_FRAGMENT_CONTEXT
from eiffel_loop.distutils import file_util
from eiffel_loop.scons.util import scons_command
from eiffel_loop import tar
from subprocess import call

global ise, Path_key
ise = ise_environ.shared

Path_key = 'PATH'

def additional_search_paths (new_path):
	# additional paths found in `new_path' not in `os.environ [Path_key]'
	old_set = set (os.environ [Path_key].split (os.pathsep))
	new_set = set (new_path.split (os.pathsep))
	result = new_set.difference (old_set)
	result.discard ('')
	return list (result)

def read_project_py ():
	# read project configuration from `project.py'
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

def new_eiffel_project (use_ecf = False):
	if os.name == "posix":
		result = UNIX_EIFFEL_PROJECT (None, use_ecf)
	else:
		result = MSWIN_EIFFEL_PROJECT (None, use_ecf)
	return result

def convert_pecf_to_xml (pecf_path):
	# Generate new ecf XML file
	result = call (['el_eiffel', '-pecf_to_xml', '-no_highlighting', '-in', pecf_path])
	if result > 0:
		print "Error converting %s to XML" % (pecf_path)
	return result

def set_build_environment (config, set_MSC=True):
	# set build environment from `project.py' config

	if sys.platform == 'win32' and set_MSC and config.MSC_options:
		print 'Configuring environment for MSC_options: ' + ' '.join (config.MSC_options)
		print "ise.msvc_version", ise.msvc_version

		sdk = C_dev.MICROSOFT_SDK (config.MSC_options)
		
		compiler_environ = sdk.compiler_environ ()
		for name, value in compiler_environ.items ():
			if not (type (name) is str or type (value) is str):
				print type (name), type (value)
				exit (1)

		ms_sdk_search_paths = additional_search_paths (compiler_environ [Path_key])

		os.environ.update (compiler_environ)

		if sdk.is_x86_cpu ():
			ise.set_archictecture (32)

	else:
		ms_sdk_search_paths = None

	ise.update () # update ISE_* variables to match C compiler

	for key, value in config.environ_extra.items ():
		os.environ [key] = path.expandvars (value)

	path_parts = [environ.system_path ()]
	if ms_sdk_search_paths:
		path_parts.extend (ms_sdk_search_paths)
	
	path_parts.extend (config.path_extra)
	path_parts.append (environ.user_path ())
	os.environ [Path_key] = path.expandvars (os.pathsep.join (path_parts))
	
def update_ecf (ecf_path):
	# update 'ecf' file from 'pecf' file if it exists
	pecf_path = path.as_pecf (ecf_path)
	if path.exists (pecf_path):
		if os.stat (pecf_path)[stat.ST_MTIME] > os.stat (ecf_path)[stat.ST_MTIME]:
			convert_pecf_to_xml (pecf_path)
	
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

	Project_py = "project.py"

	Project_py_template = "project-%d.py"

# Initialization
	def __init__ (self, ecf_name = None, use_ecf = False):
		if ecf_name:
			self.ecf_name = ecf_name
		else:
			self.ecf_name = glob ('*.ecf')[0]
		self.name = path.splitext (self.ecf_name)[0]
		self.pecf_name = self.name + '.pecf'
		if not use_ecf:
			update_ecf (self.ecf_name)
		
		system = SYSTEM_INFO (XPATH_ROOT_CONTEXT (self.ecf_name, 'ec'))
		self.exe_name = system.exe_name ()
		self.version = system.version ().short_string ()
		self.default_installation_dir = path.join (system.installation_dir (), 'bin')

		py = read_project_py ()
		self.build_f_code_tar = py.build_f_code_tar

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

	def build_target (self):
		if self.build_f_code_tar:
			result = self.f_code_tar_path ()
		else:
			result = self.f_code_exe_path ()

		return result

	def f_code_tar_path (self):
		return path.join ('build', 'F_code-%s.tar' % self.platform_name ()) 

	def f_code_exe_path (self):
		return path.join (self.eifgens_dir (), 'classic', 'F_code', self.exe_name)

# Basic operation
	def autotest (self):
		# call -autotest option on finalized exe
		# returns 0 if no error
		exe_path = self.package_exe_path ()
		if path.exists (exe_path):
			result = call ([exe_path, '-autotest'])
		else:
			print 'EXE not found', exe_path
			result = 1
		return result

	def build (self, cpu_target, options_extra = None):
		if cpu_target == 'x86':
			if path.exists (self.Project_py_template % 32):
				os.rename (self.Project_py, self.Project_py_template % 64)
				os.rename (self.Project_py_template % 32, self.Project_py)
			else:
				raise Exception ("Missing file: " + self.Project_py_template % 32)

		options = ['action=finalize']
		if options_extra:
			options.extend (options_extra)
			
		call (scons_command (options))
		if cpu_target == 'x86':
			os.rename (self.Project_py, self.Project_py_template % 32)
			os.rename (self.Project_py_template % 64, self.Project_py)

	def remove_tar_if_corrupt (self):
		# remove corrupted F_code archive if it appears to be corrupted (size is less than 1 mb)
		if self.build_f_code_tar:
			f_code_tar = self.f_code_tar_path ()
			if path.exists (f_code_tar):
				if os.path.getsize (f_code_tar) < 1000000:
					os.remove (f_code_tar)


	def clean_build (self):
		l_dir = self.eifgens_dir ()
		if path.exists (l_dir):
			dir_util.remove_tree (l_dir)

		f_code_tar = self.f_code_tar_path ()
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

	def link (self, target, link_name, sudo):
		pass

	def install (self, a_install_dir, f_code = False):
		if a_install_dir == "default":
			install_dir = self.default_installation_dir
		else:
			install_dir = a_install_dir
			
		# Install linked version of executable in `install_dir'
		if f_code:
			exe_path = self.f_code_exe_path ()
		else:
			exe_path = self.package_exe_path ()

		print 'install_dir', install_dir, self.versioned_exe_name ()

		exe_dest_path = path.join (install_dir, self.versioned_exe_name ())

		self.copy (exe_path, exe_dest_path)
		print "Copied " + exe_path + " to", install_dir

		if self.link (exe_dest_path, path.join (install_dir, self.exe_name), 'sudo') == 0:
			print 'Linked', self.exe_name, '->', exe_dest_path
		else:
			print "Link error"

		script_path = path.join (path.dirname (self.package_exe_path ()), self.exe_name + '.sh')
		if path.exists (script_path):
			self.copy (script_path, path.join (install_dir, path.basename (script_path)))
			print "Copied " + script_path + " to", install_dir

		for so_path in self.shared_object_list (path.dirname (exe_path)):
			dest_so_path = path.join (install_dir, path.basename (so_path))
			if not path.exists (dest_so_path):
				self.copy (so_path, dest_so_path)
				print 'Copied', so_path

	def increment_build_number (self, use_ecf = False):
		print 'version:', self.version
		if path.exists (self.pecf_name) and not use_ecf:
			print "Using Pyxis ECF:", self.ecf_name
			project = PYXIS_FORMAT_PROJECT_FILE (self.pecf_name)
		else:
			print "Using ECF:", self.ecf_name
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

	def link (self, target, link_name, sudo = None):
		cmd = ['ln', '-f', '-s', target, link_name]
		if sudo:
			cmd.insert (0, sudo)
		return call (cmd)

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

	def link (self, target, link_name, sudo = None):
		if path.exists (link_name):
			os.remove (link_name)
		# need `shell = True' because `mklink' is built-in command
		return call (['mklink', link_name, target], shell = True)

# Implementation

	def versioned_exe_name (self):
		template = "%s" + '-' + self.version + "%s"
		return template % path.splitext (self.exe_name)

#end class

