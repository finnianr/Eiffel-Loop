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

from eiffel_loop import osprocess
from eiffel_loop.distutils import dir_util, file_util
from eiffel_loop.xml.xpath import XPATH_CONTEXT
from eiffel_loop.eiffel import project

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
	def __init__ (self, ecf_path, top_level = False):
		self.location = ecf_path
		ecf_ctx = XPATH_CONTEXT (ecf_path, 'ec')
		self.uuid = ecf_ctx.attribute ("/ec:system/@uuid")
		self.name = ecf_ctx.attribute ("/ec:system/@name")

		self.libraries_table = {self.uuid : self}

		self.precompile_path = None
		if top_level:
			self.__set_top_level_properties (ecf_ctx)

		self.external_libs = self.__external_libs (ecf_ctx)
		self.c_shared_objects = self.__external_shared_objects (ecf_ctx)

		library_condition = "not (starts-with(@location,'$ISE_LIBRARY')) and count (%s)=0" % self.__excluded_library_or_external_object_conditions ()
		xpath = "//ec:system/ec:target/ec:library[%s]/@location" % library_condition
		
		for attrib in ecf_ctx.node_list (xpath):
			location = expanded_path (attrib)
			#print 'location:', location
			if not path.isabs (location):
				location = path.join (path.dirname (ecf_path),  location)
			# Recurse ecf file
			ecf = EIFFEL_CONFIG_FILE (location)
			self.libraries_table [ecf.uuid] = ecf
			for uuid in ecf.libraries_table:
				self.libraries_table [uuid] = ecf.libraries_table [uuid]

		if top_level:
			self.libraries = []
			for uuid in self.libraries_table:
				self.libraries.append (self.libraries_table [uuid])
		
# Implementation

	def __set_top_level_properties (self, ecf_ctx):
		self.exe_name = ecf_ctx.attribute ('/ec:system/@name')

		self.system_type = ecf_ctx.attribute ('/ec:system/ec:target/@name')

		self.dir_build_info = ecf_ctx.attribute ("/ec:system/ec:target/ec:variable[@name='dir_build_info']/@value")
		if not self.dir_build_info:
			self.dir_build_info = 'source'

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

		self.ise_platform = os.environ ['ISE_PLATFORM']
		
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
		self.dir_build_info = self.ecf.dir_build_info
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

	def target (self):
		# Build target as for example:
		# 'build/win64/EIFGENs/classic/F_code/myching.exe'
		result = os.sep.join (self.target_steps ())
		return result

	def target_steps (self):
		result = ['build', self.ise_platform, 'EIFGENs', self.system_type, self.build_type (), self.exe_name]
		return result

	def win64_target (self):
		steps = self.target_steps ()
		steps [1] = 'win64'
		result = os.sep.join (steps)
		return result

	def exe_path (self):
		return self.target ()

	def code_dir_path (self):
		return path.dirname (self.target ())
	
	def project_path (self):
		return path.join ('build', self.ise_platform)

	def compilation_options (self):
		return ['-freeze']

	def resources_destination (self):
		self.write_io ('resources_destination freeze\n')
		return self.installation_dir ()

	def installation_dir (self):
		if is_unix:
			result = path.join ('/opt', self.installation_sub_directory)
		else:
			suffix = ''
			# In case you are compiling a 32 bit version on a 64 bit machine.
			if self.ise_platform == 'windows' and os_platform.machine () == 'AMD64':
				suffix = ' (x86)'
			result = path.join ('c:\\Program files' + suffix, path.normpath (self.installation_sub_directory))
			
		return result

	def archive_target (self):
		return path.join ('build', os_platform.system () + '-F_code.tar.gz')
	
# Status query
	

# Basic operations	
	def pre_compilation (self):
		self.__write_class_build_info ()
	
	def compile (self):
		# Will automatically do precompile if needed
		cmd = ['ec', '-batch', '-c_compile'] + self.compilation_options () + ['-config', self.ecf_path, '-project_path', self.project_path ()]
		self.write_io ('cmd = %s\n' % cmd)
			
		ret_code = call (cmd)

	def post_compilation (self):
		self.install_resources (self.resources_destination ())

	def install_resources (self, destination_dir):
		print 'Installing resources in:', destination_dir
		copy_tree, copy_file, remove_tree, mkpath = self.__file_command_set (destination_dir)

		if not path.exists (destination_dir):
			mkpath (destination_dir)
		resource_root_dir = "resources"
		if path.exists (resource_root_dir):
			excluded_dirs = ["workarea"]
			resource_list = [
				path.join (resource_root_dir, name) 
					for name in os.listdir (resource_root_dir ) if not name in excluded_dirs
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
		copy_tree, copy_file, remove_tree, mkpath = self.__file_command_set (destination_dir)

		bin_dir = path.join (destination_dir, 'bin')
		mkpath (bin_dir)
		
		# Copy executable including possible Windows 7 manifest file
		for exe_path in glob (path.join (self.code_dir_path (), self.exe_name + '*')):
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
			f.close

# Implementation

	def __file_command_set (self, destination_dir):
		# return appropriate file commands for required permissions in destination_dir
	
		if path.basename (destination_dir) == self.ise_platform:
			result = (dir_util.copy_tree, file_util.copy_file, dir_util.remove_tree, dir_util.mkpath)

		else: # Admin permission required
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

	def write_io (self, str):
		sys.stdout.write (str)

	def __write_class_build_info (self):
		self.write_io ('__write_class_build_info\n')
		file_path = path.join (path.normpath (self.dir_build_info), 'build_info.e')

		build_no = 1
		if path.exists (file_path):
			f = open (file_path, 'r')
			for line in f.readlines ():
				if line.startswith ('\tBuild_number'):
					build_no = int (line.split ()[-1:][0]) + 1
					break
			f.close ()
		
		f = open (file_path, 'w')
		f.write (
			build_info_class_template.substitute (
				version = "%02d_%02d_%02d" % self.version, 
				build_no = build_no,
				# Assumes unix separator
				installation_sub_directory = self.installation_sub_directory
			)
		)
		f.close

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

class FINALIZE_BUILD (FREEZE_BUILD):

# Access
	def build_type (self):
		return 'F_code'

	def compilation_options (self):
		return ['-finalize']

	def resources_destination (self):
		return path.join ('build', self.ise_platform, 'package')

# Status query

# Basic operations
	def post_compilation (self):
		destination = self.resources_destination ()
		self.install_resources (destination)
		self.install_executables (destination)
		
# end FINALIZE_BUILD

class RECOMPILED_X64_FINALIZE_BUILD (FINALIZE_BUILD):
# Recyles an existing win64 F_code target for x86 build

# Basic operations
	def compile (self):
		self.__copy_win64_F_code ()

		curdir = path.abspath (os.curdir)
		os.chdir (self.code_dir_path ())
		ret_code = osprocess.call (['finish_freezing'])
		os.chdir (curdir)

# Implementation

	def __copy_win64_F_code (self):
		f_code_tar_path = project.create_classic_f_code_tar ('win64')

		file_util.copy_file (r'build\win64\myching.rc', r'build\windows')

		project.restore_classic_f_code_tar (f_code_tar_path, 'windows')

		os.remove (f_code_tar_path)

# end RECOMPILED_X64_FINALIZE_BUILD

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

	Build_number: NATURAL = ${build_no}

	Installation_sub_directory: EL_DIR_PATH
		once
			create Result.make_from_unicode ("${installation_sub_directory}")
		end

end''')

launch_script_template = '''#!/usr/bin/env bash
export LD_LIBRARY_PATH="%s"
"$LD_LIBRARY_PATH/%s" $*
'''
