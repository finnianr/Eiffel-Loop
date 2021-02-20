#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "2 June 2010"
#	revision: "0.1"

import string, os, sys, re
import platform as os_platform

from string import Template
from glob import glob
from os import path

from eiffel_loop.eiffel import ise

from eiffel_loop import osprocess
from eiffel_loop.distutils import dir_util, file_util
from eiffel_loop.xml.xpath import XPATH_ROOT_CONTEXT
from eiffel_loop.xml.xpath import XPATH_CONTEXT
from eiffel_loop.tar import ARCHIVE

from subprocess import call

global Build_info_class_template

def programs_suffix ():
	if sys.platform == 'win32':
		result = '.exe'
	else:
		result = ''
	return result

def expanded_path (a_path):
	result = path.normpath (a_path.translate (string.maketrans ('\\','/')))
	result = path.expandvars (result)
	return result

def put_unique (list, elem):
	if not elem in list:
		list.append (elem)

def is_platform_unix ():
	return os.name == 'posix'

def is_platform_windows ():
	return os.name == 'nt'

def platform_name ():
	if is_platform_unix ():
		result = 'unix'
	else:
		result = 'windows'
	return result

def opposing_platform (value):
	result = 'unix'
	if value == result:
		result = 'windows'

	return result

# Recursively defined Eiffel Configuration File

class SYSTEM_VERSION (object):
# Initialization
	def __init__ (self, system_ctx):
		if not isinstance (system_ctx, XPATH_CONTEXT):
			raise ValueError ("system_ctx is not a XPATH_CONTEXT")

		ctx = system_ctx.context_list ("target[@name='classic']/version")
		if len (ctx) > 0:
			version_ctx = ctx [0]
			for k, v in version_ctx.attrib_table ().items():
				setattr (self, k, v)
		else:
			self.major = '0'
			self.minor = '0'
			self.release = '0'
			self.build = '0'
			self.company = ''
			self.copyright = ''
			self.product = ''

	def tuple_3 (self):
		result = (self.major, self.minor, self.release)
		return result

	def tuple_4 (self):
		result = (self.major, self.minor, self.release, self.build)
		return result

	def long_string (self):
		result = "%s.%s.%s build %s" % self.tuple_4 ()
		return result

	def short_string (self):
		result = "%s.%s.%s" % self.tuple_3 ()
		return result

	def compact (self):
		return "%02d_%02d_%02d" % (int (self.major), int (self.minor), int (self.release))
		

class LIBRARY (object):
	windows = "windows"
	platform_attributes = ['value', 'excluded_value']

# Initialization
	def __init__ (self, ctx):
		self.ctx = ctx
		if not isinstance (ctx, XPATH_CONTEXT):
			raise ValueError ("ctx is not a XPATH_CONTEXT")

		self.platform = platform_name ()
		for name in self.platform_attributes:
			value = ctx.attribute ("condition/platform/@" + name)
			if value:
				if name.startswith ('excluded'):
					if value == self.platform:
						self.platform = opposing_platform (value)
				else:
					self.platform = value
				break

# Access	
	def location (self):
		result = self.ctx.attribute ('@location')
		return result

	def expanded_location (self, ecf_path):
		result = expanded_path (self.location ())
		if not path.isabs (result):
			result = path.normpath (path.join (path.dirname (ecf_path), result))
		return result

	def is_ise (self):
		return self.location ().startswith ('$ISE_')

class EXTERNAL_OBJECT (LIBRARY):
	multithreaded_conditions = {
		'concurrency': { 'value' : 'none', 'excluded_value' : 'none' },
		'multithreaded': { 'value' : 'false', 'excluded_value' : 'false' }
	}

# Initialization
	def __init__ (self, ctx):
		LIBRARY.__init__ (self, ctx)

		self.is_multithreaded = True
		done = False
		for name, table in self.multithreaded_conditions.items ():
			for attribute_name, false_value in table.items ():
				value = ctx.attribute ("condition/%s/@%s" % (name, attribute_name))
				if value:
					if attribute_name.startswith ('excluded'):
						self.is_multithreaded = value.lower () == false_value
					else:
						self.is_multithreaded = value.lower () != false_value
					done = True
					break
			if done:
				break

		self.is_shared = False
		# Eiffel-Loop only, see for example: library/image-utils.ecf
		value = ctx.attribute ("condition/custom[@name='link_object']/@value")
		if value:
			self.is_shared = value.lower() == 'true'

# Access
	def library (self):
		prefix = ''
		result = self.location ().translate (None , '()')
		if result != 'none':
			for part in result.split():
				lib = part.strip()
				if lib.startswith ('-L'):
					prefix = lib [2:]
					prefix = prefix.strip ('"')
				else:
					if prefix:
						result = expanded_path (path.join (prefix, 'lib%s.a' % lib [2:]))
					elif lib.startswith ('-l'):
						result = lib
					else:
						result = expanded_path (lib)
		return result

	def shared_libraries (self):
		result = []
		description = self.ctx.text ("description")
		if description:
			if description.find ('requires:') > 0:
				# Add lines skipping 1st
				requires_list = description.strip().splitlines ()[1:]
				for lib in requires_list:
					result.append (expanded_path (lib))
	
		return result

# Status query
	def matches_multithreaded (self, platform):
		return self.platform == platform and self.is_multithreaded


class SYSTEM_INFO (object):
# Initialization
	def __init__ (self, root_ctx):
		if not isinstance (root_ctx, XPATH_ROOT_CONTEXT):
			raise ValueError ("root_ctx is not a XPATH_ROOT_CONTEXT")

		self.ctx = root_ctx.context_list ('/system')[0]
		for k, v in self.ctx.attrib_table ().items():
			setattr (self, k, v)
		
		self.platform = platform_name ()

# Access
	def build_info_path (self):
		# attempt to get location of 'build_info.e' file from ECF, defaulting to 'source' if not found

		result = self.ctx.attribute ("target[1]/variable[@name='build_info_dir']/@value")
		if result:
			result = path.normpath (result)
		else:
			result = 'source'
		result = path.join (result, 'build_info.e')
		return result	

	def exe_name (self):
		if is_platform_windows ():
			result = self.name + '.exe'
		else:
			result = self.name
		return result

	def type (self):
		# classic | dotnet
		return self.ctx.attribute ('target[1]/@name')

	def version (self):
		return SYSTEM_VERSION (self.ctx)

	def precompile_path (self):
		result = self.ctx.attribute ('target[1]/precompile/@location')
		if result:
			result = expanded_path (result)
		return result

	def installation_sub_directory (self):
		version = self.version ()
		result = '/'.join ([version.company, version.product])
		return result

	def installation_dir (self):
		# absolute installation direction in either /opt or C:\\Program files
		installation_sub_directory = path.normpath (self.installation_sub_directory ())
		if is_platform_unix ():
			result = path.join ('/opt', installation_sub_directory)
		else:
			suffix = ''
			# In case you are compiling a 32 bit version on a 64 bit machine.
			if ise.platform == 'windows' and os_platform.machine () == 'AMD64':
				suffix = ' (x86)'
			result = path.join ('c:\\Program files' + suffix, installation_sub_directory)
			
		return result

# Basic operations
	def write_build_info (self):
		# Write the Eiffel source file `BUILD_INFO' containing version information
		version = self.version ()
		f = open (self.build_info_path (), 'w')
		f.write (
			Build_info_class_template.substitute (
				version = version.compact (),
				build_number = version.build,
				# Assumes unix separator
				installation_sub_directory = self.installation_sub_directory ()
			)
		)
		f.close ()

	def write_version_text (self):
		# Write build/version.txt
		f = open (path.join ('build', 'version.txt'), 'w')
		f.write ("%s.%s.%s" % self.version ().tuple_3 ())
		f.close ()

class EIFFEL_CONFIG_FILE (object):

# Initialization
	def __init__ (self, ecf_path, ecf_table = dict ()):
		self.location = ecf_path
		ecf_ctx = XPATH_ROOT_CONTEXT (ecf_path, 'ec')
		system = SYSTEM_INFO (ecf_ctx)
		
		self.uuid = system.uuid
		self.name = system.name
		self.platform = system.platform
		self.keep_assertions = False

		self.libraries_table = {self.uuid : self}

		self.precompile_path = None
		top_level = len (ecf_table) == 0
		if top_level:
			self.__set_top_level_properties (system)
			print "\nLibraries:",

		print path.basename (ecf_path) + ',',

		ecf_table [ecf_path] = self

		objects_list = self.__new_external_objects_list (ecf_ctx)
		self.external_libs = self.__external_libs (objects_list)
		self.c_shared_objects = self.__external_shared_objects (objects_list)

		for library in self.__new_library_list (ecf_ctx):
			location = library.expanded_location (ecf_path)

			# prevent infinite recursion for circular references
			if ecf_table.has_key (location):
				ecf = ecf_table [location]
			else:
				# Recurse ecf file
				ecf = EIFFEL_CONFIG_FILE (location, ecf_table)

			self.libraries_table [ecf.uuid] = ecf
			for uuid in ecf.libraries_table:
				self.libraries_table [uuid] = ecf.libraries_table [uuid]
		if top_level:
			self.libraries = []
			for uuid in self.libraries_table:
				self.libraries.append (self.libraries_table [uuid])
			print ''
			print ''
		
# Implementation

	def __set_top_level_properties (self, system):
		self.exe_name = system.exe_name ()
		self.system_type = system.type ()
		self.system = system
		self.precompile_path = system.precompile_path ()

	def __external_libs (self, objects_list):
		result = []
		for external in objects_list:
			if external.matches_multithreaded (self.platform):
				result.append (external.library ())
		return result

	def __external_shared_objects (self, objects_list):
		# Find shared objects (dll files, jar files, etc) in description field containing "requires:"
		result = []
		for external in objects_list:
			if external.matches_multithreaded (self.platform):
				shared = external.shared_libraries ()
				if shared:
					result.extend (shared)
		return result

	def __new_library_list (self, ecf_ctx):
		# list of non ISE libraries
		result = []
		for ctx in ecf_ctx.context_list ('/system/target[1]/library'):
			library = LIBRARY (ctx)
			#print library.location (), library.platform
			if not library.is_ise () and library.platform == self.platform:
				result.append (library)
		return result

	def __new_external_objects_list (self, ecf_ctx):
		result = []
		for ctx in ecf_ctx.context_list ('/system/target[1]/external_object'):
			result.append (EXTERNAL_OBJECT (ctx))
		return result

class FREEZE_BUILD (object):

# Initialization
	def __init__ (self, ecf, project_py):
		self.ecf = ecf
		self.system = ecf.system
		self.ecf_path = ecf.location
		self.pecf_path = None

		ecf_path_parts = path.splitext (self.ecf_path)
		if ecf_path_parts [1] == '.pecf':
			self.pecf_path = self.ecf_path
			self.ecf_path = ecf_path_parts [0] + '.ecf'

		self.io = None

		self.implicit_C_libs = []
		self.explicit_C_libs = []

		self.scons_buildable_libs = []
		self.SConscripts = []

		self.precompile_path = self.ecf.precompile_path
		self.exe_name = self.ecf.exe_name
		self.system_type = self.ecf.system_type
		self.library_names = []

		print 'Precompile: '
		print '  ', self.precompile_path

		# Collate C libraries into lists for explict libs (absolute path), implicit libs (in libary path)
		# and those that have a SConscript.

		for ecf in self.ecf.libraries:
			self.library_names.append (ecf.name)
			if ecf.external_libs:
				print 'For %s:' % path.basename (ecf.location)
				for lib in ecf.external_libs:
					print '  ', lib
					if lib.startswith ('-l'):
						put_unique (self.implicit_C_libs, lib [2:])

					elif lib.endswith ('.lib') and not path.dirname (lib):
						put_unique (self.implicit_C_libs, lib [:-4])

					elif self.__has_SConscript (lib):
						if not lib in self.scons_buildable_libs:
							self.scons_buildable_libs.append (lib)
							self.SConscripts.append (self.__SConscript_path (lib))
					else:
						put_unique (self.explicit_C_libs, lib)

			for object_path in ecf.c_shared_objects:
				print '   Dynamically loaded:', object_path
				if not path.basename (object_path).startswith ('*.'):
					if self.__has_SConscript (object_path):
						if not object_path in self.scons_buildable_libs:
							self.scons_buildable_libs.append (object_path)
							self.SConscripts.append (self.__SConscript_path (object_path))

# Access
	def build_type (self):
		return 'W_code'

	def code_dir (self):
		# Example: build/win64/EIFGENs/classic/F_code

		result = os.sep.join (self.code_dir_steps ())
		return result

	def code_dir_steps (self):
		result = ['build', ise.platform, 'EIFGENs', self.system_type, self.build_type ()]
		return result

	def target (self):
		# Build target as for example:
		# 'build/win64/EIFGENs/classic/F_code/myching.exe'
		result = os.sep.join (self.target_steps ())
		return result

	def target_steps (self):
		result = self.code_dir_steps ()
		result.append (self.exe_name)
		return result

	def exe_path (self):
		return self.target ()

	def f_code_tar_steps (self):
		result = ['build', 'F_code-%s.tar' % self.ecf.platform]
		return result

	def f_code_tar_unix_path (self):
		result = '/'.join (self.f_code_tar_steps ())
		return result

	def f_code_tar_path (self):
		result = os.sep.join (self.f_code_tar_steps ())
		return result
	
	def project_path (self):
		return path.join ('build', ise.platform)

	def compilation_options (self):
		return ['-freeze', '-c_compile']

	def resources_destination (self):
		self.write_io ('resources_destination freeze\n')
		return self.system.installation_dir ()

# Status query
	

# Basic operations	
	def pre_compilation (self):
		self.system.write_build_info ()
		self.system.write_version_text ()

		# Make build/win64, etc
		project_path = os.sep.join (self.code_dir_steps ()[:2])
		if not path.exists (project_path):
			dir_util.mkpath (project_path)
	
	def compile (self):
		# Will automatically do precompile if needed
		cmd = ['ec', '-batch'] + self.compilation_options () + ['-config', self.ecf_path, '-project_path', self.project_path ()]
		self.write_io ('cmd = %s\n' % cmd)
			
		ret_code = call (cmd)

	def post_compilation (self):
		self.install_resources (self.resources_destination ())

	def install_resources (self, destination_dir):
		print 'Installing resources in:', destination_dir
		copy_tree, copy_file, remove_tree, mkpath = self._file_command_set (destination_dir)

		if not path.exists (destination_dir):
			mkpath (destination_dir)
		resource_root_dir = "resources"
		if path.exists (resource_root_dir):
			excluded_dirs = ["workarea"]
			resource_list = [
				path.join (resource_root_dir, name) for name in os.listdir (resource_root_dir ) if not name in excluded_dirs
			]
			for resource_path in resource_list:
				basename = path.basename (resource_path)
				self.write_io ('Installing %s\n' % basename)
				if path.isdir (resource_path):
					resource_dest_dir = path.join (destination_dir, basename)
					if path.exists (resource_dest_dir):
						remove_tree (resource_dest_dir)	
					copy_tree (resource_path, resource_dest_dir)	
				else:
					copy_file (resource_path, destination_dir)

	def install_executables (self, destination_dir):
		print 'Installing executables in:', destination_dir
		copy_tree, copy_file, remove_tree, mkpath = self._file_command_set (destination_dir)

		bin_dir = path.join (destination_dir, 'bin')
		if not path.exists (bin_dir):
			mkpath (bin_dir)
		
		# Copy executable including possible Windows 7 manifest file
		for exe_path in glob (path.join (self.code_dir (), self.exe_name + '*')):
			copy_file (exe_path, bin_dir)

		self.write_io ('Copying shared object libraries\n')
		shared_objects = self.__shared_object_libraries ()
		for so in shared_objects:
			copy_file (so, bin_dir)

		if shared_objects and is_platform_unix ():
			install_bin_dir = path.join (self.system.installation_dir (), 'bin')
			script_path = path.join (bin_dir, self.exe_name + '.sh')
			f = open (script_path, 'w')
			f.write (launch_script_template % (install_bin_dir, self.exe_name))
			f.close ()

	def write_io (self, str):
		sys.stdout.write (str)

# Implementation

	def _file_command_set (self, destination_dir):
		self.write_io ("using root copy permissions\n")
		result = (dir_util.sudo_copy_tree, file_util.sudo_copy_file, dir_util.sudo_remove_tree, dir_util.sudo_mkpath)
	
		return result

	def __shared_object_libraries (self):
		result = []
		for ecf in self.ecf.libraries:
			for object_path in ecf.c_shared_objects:
				object_path = expanded_path (object_path)
				if path.basename (object_path).startswith ('*.'):
					result.extend (glob (object_path))
				else:
					result.append (object_path)

		return result

	def __SConscript_path (self, lib):
		#print "__SConscript_path (%s)" % lib
		lib_path = path.dirname (lib)
		lib_steps = lib_path.split (os.sep)
		
		if 'spec' in lib_steps:
			lib_path = lib_path [0: lib_path.find ('spec') - 1]

		result = path.join (lib_path, 'SConscript')
		#print result
		return result
	
	def __has_SConscript (self, lib):
		lib_sconscript = self.__SConscript_path (lib)
		result = path.exists (lib_sconscript)
		# print lib, "has", lib_sconscript, result
		return result

# end FREEZE_BUILD

class C_CODE_TAR_BUILD (FREEZE_BUILD):
# Generates cross-platform Finalized_code.tar

# Access
	def build_type (self):
		return 'F_code'

	def target_steps (self):
		result = self.f_code_tar_steps ()
		return result

	def compilation_options (self):
		result = ['-finalize']
		if ecf.keep_assertions:
			result.append ('-keep')
		return result

# Status query

# Basic operations
	def compile (self):
		super (C_CODE_TAR_BUILD, self).compile ()
		tar_path = self.f_code_tar_path ()
		if path.exists (tar_path):
			os.remove (tar_path)
		self.write_io ('Archiving to: %s\n' % tar_path)

		tar = ARCHIVE (self.f_code_tar_unix_path ())
		tar.chdir = '/'.join (self.code_dir_steps ()[0:-1])
		tar.append ('F_code')

		code_dir = self.code_dir ()
		dir_util.remove_tree (code_dir)
		dir_util.mkpath (code_dir) # Leave an empty F_code directory otherwise EiffelStudio complains
		
# end C_CODE_TAR_BUILD

class FINALIZED_BUILD (FREEZE_BUILD):
# extracts Finalized_code.tar and compiles to executable, and then deletes `F_code'

# Access
	def build_type (self):
		return 'F_code'

	def resources_destination (self):
		return path.join ('build', ise.platform, 'package')

	def target_steps (self):
		result = self.resources_destination ().split (os.sep) + ['bin', self.exe_name]
		return result

# Basic operations
	def pre_compilation (self):
		pass

	def compile (self):
		code_dir = self.code_dir ()
		classic_dir = path.dirname (code_dir)
		if path.exists (classic_dir):
			if path.exists (code_dir):
				dir_util.remove_tree (code_dir)
		else:
			dir_util.mkpath (classic_dir)

		tar_path = self.f_code_tar_unix_path ()
		tar = ARCHIVE (tar_path)
		tar.chdir = '/'.join (self.code_dir_steps ()[0:-1])
		self.write_io ('Extracting: %s\n' % tar_path)
		tar.extract ()

		curdir = path.abspath (os.curdir)
		os.chdir (self.code_dir ())
		ret_code = osprocess.call (['finish_freezing'])
		os.chdir (curdir)

	def post_compilation (self):
		destination = self.resources_destination ()
		self.install_resources (destination)
		self.install_executables (destination)

		code_dir = self.code_dir ()
		dir_util.remove_tree (code_dir)
		dir_util.mkpath (code_dir)

# Implementation

	def _file_command_set (self, destination_dir):
		self.write_io ("using normal copy permissions\n")
		result = (dir_util.copy_tree, file_util.copy_file, dir_util.remove_tree, dir_util.mkpath)
		return result

# end FINALIZED_BUILD

class FINALIZE_AND_TEST_BUILD (FREEZE_BUILD): # Obsolete July 2012

# Initialization
	def __init__ (self, ecf, project_py):
		FREEZE_BUILD.__init__ (self, ecf, project_py)
		self.tests = project_py.tests

# Access
	def compilation_options (self):
		return ['-finalize', '-keep']

# Status query

# Basic operations

	def post_compilation (self):
		bin_test_path = path.normpath ('package/test')
		self.install_executables (bin_test_path)
		if self.tests:
			self.do_tests ()
	
	def do_tests (self):
		bin_test_path = path.normpath ('package/test')
		self.tests.do_all (path.join (bin_test_path, self.exe_name))

# end FINALIZE_AND_TEST_BUILD

Build_info_class_template = Template (
'''note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = ${version}

	Build_number: NATURAL = ${build_number}

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "${installation_sub_directory}"
		end

end''')

launch_script_template = '''#!/usr/bin/env bash
export LD_LIBRARY_PATH="%s"
"$LD_LIBRARY_PATH/%s" $*
'''
