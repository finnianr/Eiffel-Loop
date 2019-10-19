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
from eiffel_loop.xml.xpath import XPATH_CONTEXT
from eiffel_loop.eiffel import project
from eiffel_loop.tar import ARCHIVE

from subprocess import call

global platform, is_unix

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

platform  = os_platform.system ().lower ()
if platform in ['unix', 'linux']:
	platform  = 'unix'
	is_unix = True
else:
	is_unix = False

# Recursively defined Eiffel Configuration File

class EIFFEL_CONFIG_FILE (object):

# Initialization
	def __init__ (self, ecf_path, ecf_table = dict ()):
		self.location = ecf_path
		ecf_ctx = XPATH_CONTEXT (ecf_path, 'ec')
		self.uuid = ecf_ctx.attribute ("/ec:system/@uuid")
		self.name = ecf_ctx.attribute ("/ec:system/@name")

		self.libraries_table = {self.uuid : self}

		self.precompile_path = None
		top_level = len (ecf_table) == 0
		if top_level:
			self.__set_top_level_properties (ecf_ctx)
			print "\nLibraries:",

		print path.basename (ecf_path), ',',

		ecf_table [ecf_path] = self

		self.external_libs = self.__external_libs (ecf_ctx)
		self.c_shared_objects = self.__external_shared_objects (ecf_ctx)

		library_condition = "not (starts-with(@location,'$ISE_LIBRARY')) and count (%s)=0" % self.__excluded_library_or_external_object_conditions ()
		xpath = "//ec:system/ec:target/ec:library[%s]/@location" % library_condition
		
		for attrib in ecf_ctx.node_list (xpath):
			location = expanded_path (attrib)
			#print 'location:', location
			if not path.isabs (location):
				location = path.normpath (path.join (path.dirname (ecf_path), location))

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

	def __set_top_level_properties (self, ecf_ctx):
		self.exe_name = ecf_ctx.attribute ('/ec:system/@name')

		self.system_type = ecf_ctx.attribute ('/ec:system/ec:target/@name')

		self.build_info_path = project.build_info_path (ecf_ctx)

		location = ecf_ctx.attribute ('/ec:system/ec:target/ec:precompile/@location')
		if location:
			self.precompile_path = expanded_path (location)

	def __external_libs (self, ecf_ctx):
		xpath = "//ec:system/ec:target/ec:external_object [count (%s)=0]/@location" % self.__excluded_library_or_external_object_conditions ()
		result = []
		for location in ecf_ctx.node_list (xpath):
			# remove bracketed substitution vars
			prefix = ''
			location = location.translate (None , '()')
			if location != 'none':
				for part in location.split():
					lib = part.strip()
					if lib.startswith ('-L'):
						prefix = lib [2:]
						prefix = prefix.strip ('"')
					else:
						if prefix:
							result.append (expanded_path (path.join (prefix, 'lib%s.a' % lib [2:])))
						elif lib.startswith ('-l'):
							result.append (lib)
						else:
							result.append (expanded_path (lib))
			
		return result

	def __external_shared_objects (self, ecf_ctx):
		# Find shared objects (dll files, jar files, etc) in description field containing "requires:"
		
		criteria = "count (%s)=0 and contains (./ec:description/text(), 'requires:')" % self.__excluded_library_or_external_object_conditions ()
		xpath = "//ec:system/ec:target/ec:external_object [%s]/ec:description" % criteria
		result = []
		for description in ecf_ctx.node_list (xpath):
			# Add lines skipping 1st
			requires_list = description.text.strip().splitlines ()[1:]
			for lib in requires_list:
				result.append (expanded_path (lib))
	
		return result

	def __excluded_library_or_external_object_conditions (self):
		object_exclusions = [
			"ec:platform/@excluded_value = '%s'" % platform,
			"ec:platform/@value != '%s'" % platform,
			"ec:multithreaded/@value = 'false'",
			"ec:dotnet/@value = 'true'",
			"ec:concurrency/@value = 'none'"
		]
		#if only_linked_objects:
		#	object_exclusions.append ("ec:custom [@name='link_object']/@value = 'true'")
		
		combined_conditions = object_exclusions [0]
		for condition in object_exclusions [1:]:
			combined_conditions = '%s or %s' % (combined_conditions, condition)
		result = "ec:condition [%s]" % combined_conditions
		return result

class FREEZE_BUILD (object):

# Initialization
	def __init__ (self, ecf, project_py):
		self.ecf = ecf
		self.ecf_path = ecf.location
		self.pecf_path = None

		ecf_path_parts = path.splitext (self.ecf_path)
		if ecf_path_parts [1] == '.pecf':
			self.pecf_path = self.ecf_path
			self.ecf_path = ecf_path_parts [0] + '.ecf'

		self.version = project_py.version
		self.build_number = project_py.build

		# This should be kept with Unix forward slash directory separator
		if '\\' in project_py.installation_sub_directory:
			self.write_io ("WARNING: file 'project.py'\n")
			self.write_io ("\tDirectory separator in 'installation_sub_directory' should always be Unix style '/'\n")
		self.installation_sub_directory = project_py.installation_sub_directory
	
		self.io = None

		self.implicit_C_libs = []
		self.explicit_C_libs = []

		self.scons_buildable_libs = []
		self.SConscripts = []

		self.precompile_path = self.ecf.precompile_path
		self.exe_name = self.ecf.exe_name + programs_suffix ()
		self.system_type = self.ecf.system_type
		self.build_info_path = self.ecf.build_info_path
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
		if is_unix:
			name = 'unix'
		else:
			name = 'windows'
		result = ['build', 'F_code-%s.tar' % name]
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
		return self.installation_dir ()

	def installation_dir (self):
		if is_unix:
			result = path.join ('/opt', self.installation_sub_directory)
		else:
			suffix = ''
			# In case you are compiling a 32 bit version on a 64 bit machine.
			if ise.platform == 'windows' and os_platform.machine () == 'AMD64':
				suffix = ' (x86)'
			result = path.join ('c:\\Program files' + suffix, path.normpath (self.installation_sub_directory))
			
		return result

# Status query
	

# Basic operations	
	def pre_compilation (self):
		self.__write_class_build_info ()
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

		if shared_objects and is_unix:
			install_bin_dir = path.join (self.installation_dir (), 'bin')
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

	def __write_class_build_info (self):
		self.write_io ('__write_class_build_info\n')
		f = open (self.build_info_path, 'w')
		f.write (
			build_info_class_template.substitute (
				version = "%02d_%02d_%02d" % self.version,
				build_number = self.build_number,
				# Assumes unix separator
				installation_sub_directory = self.installation_sub_directory
			)
		)
		f.close ()
		# Write build/version.txt
		f = open (path.join ('build', 'version.txt'), 'w')
		f.write ("%s.%s.%s" % self.version)
		f.close ()

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
		return ['-finalize']

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

build_info_class_template = Template (
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
