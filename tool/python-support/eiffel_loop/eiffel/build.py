#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2024 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "6 August 2024"
#	revision: "0.1"

import os, sys

from string import Template
from glob import glob
from subprocess import call

from eiffel_loop import platform
from eiffel_loop import osprocess
from eiffel_loop.distutils import dir_util, file_util
from eiffel_loop.eiffel import ise_environ
from eiffel_loop.os.system import new_file_system
from eiffel_loop.os import path
from eiffel_loop.tar import ARCHIVE

global Build_info_class_template, Launch_script_template, ise

ise = ise_environ.shared

class FREEZE_BUILD (object):
	
	Build_dir = 'build'
	C_compile = '-c_compile'
	Dot_manifest = '.manifest'
	Freeze = '-freeze'
	Keep = '-keep'
	Manifest_template_xml = 'manifest-template.xml'

# Initialization
	def __init__ (self, ecf, project_py):
		self.ecf = ecf
		self.system = ecf.system
		self.ecf_path = ecf.location
		self.pecf_path = None
		self.build_info_path = project_py.build_info_path
		self.preserve_resources = project_py.preserve_resources
		self.file_system = new_file_system (True)

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
						self.__put_unique (self.implicit_C_libs, lib [2:])

					elif lib.endswith ('.lib') and not path.dirname (lib):
						self.__put_unique (self.implicit_C_libs, lib [:-4])

					elif self.__has_SConscript (lib):
						if not lib in self.scons_buildable_libs:
							self.scons_buildable_libs.append (lib)
							self.SConscripts.append (self.__SConscript_path (lib))
					else:
						self.__put_unique (self.explicit_C_libs, lib)

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
		result = [self.Build_dir, ise.platform, 'EIFGENs', self.system_type, self.build_type ()]
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
		result = [self.Build_dir, 'F_code-%s.tar' % self.ecf.platform]
		return result

	def f_code_tar_unix_path (self):
		result = '/'.join (self.f_code_tar_steps ())
		return result

	def f_code_tar_path (self):
		result = os.sep.join (self.f_code_tar_steps ())
		return result
	
	def project_path (self):
		return path.join (self.Build_dir, ise.platform)

	def compilation_options (self):
		return [self.Freeze, self.C_compile]

	def resources_destination (self):
		return self.system.installation_dir ()

# Basic operations
	def install_resources (self):
		installation_dir = self.system.installation_dir ()
		preserve_list = list ()
		if self.preserve_resources:
			for resource_path in self.preserve_resources:
				resource_path_abs = path.join (installation_dir, path.normpath (resource_path))
				if path.exists (resource_path_abs):
					preserve_list.append (resource_path_abs)

		if preserve_list:
			# Preserving directories listed in 'preserve_resources' in project.py
			temp_dir = path.join (installation_dir, 'temporary')
			self.file_system.make_path (temp_dir)
			for resource_path_abs in preserve_list:
				print 'Preserving:', resource_path_abs
				self.file_system.move_tree (resource_path_abs, temp_dir)
			
			self.install_resources_to (installation_dir)

			# Restore preserved directories
			for resource_path_abs in preserve_list:
				name = path.basename (resource_path_abs)
				temp_path = path.join (temp_dir, name)
				print 'Restoring:', resource_path_abs
				self.file_system.move_tree (temp_path, path.dirname (resource_path_abs))

			self.file_system.remove_tree (temp_dir)
		else:
			self.install_resources_to (installation_dir)

	def pre_compilation (self):
		self.__write_build_info ()
		self.system.write_version_text ()

		# Make build/win64, etc
		project_path = os.sep.join (self.code_dir_steps ()[:2])
		if not path.exists (project_path):
			dir_util.mkpath (project_path)
	
	def compile (self):
		# Will automatically do precompile if needed
		cmd = ['ec', '-batch'] + self.compilation_options () + ['-config', self.ecf_path, '-project_path', self.project_path ()]
		self.write_io_line (' '.join (cmd))
		ret_code = call (cmd)

	def post_compilation (self):
		self.install_resources_to (self.resources_destination ())

	def write_io_line (self, string):
		sys.stdout.write (string)
		sys.stdout.write ('\n')

	def write_io_field (self, label, value):
		self.write_io_line ('%s: %s' % (label, value))

# Redefinable implementation

	def install_executables (self, destination_dir):
		self.write_io_field ('Installing executables in', destination_dir)
		self.__print_permission ()

		bin_dir = path.join (destination_dir, 'bin')
		if not path.exists (bin_dir):
			self.file_system.make_path (bin_dir)
		
		# Copy executable
		exe_path = path.join (self.code_dir (), self.exe_name)
		self.file_system.copy_file (exe_path, bin_dir)

		if platform.is_windows ():
			self.__copy_write_exe_manifest (bin_dir)

		self.write_io_line ('Copying shared object libraries')
		shared_objects = self.__shared_object_libraries ()
		for so in shared_objects:
			self.file_system.copy_file (so, bin_dir)

		if shared_objects and platform.is_unix ():
			self.__write_launch_script (bin_dir)

	def install_resources_to (self, destination_dir):
		self.write_io_field ('Installing resources in', destination_dir)
		self.__print_permission ()

		if not path.exists (destination_dir):
			self.file_system.make_path (destination_dir)
		resource_root_dir = "resources"
		if path.exists (resource_root_dir):
			resource_list = [path.join (resource_root_dir, name) for name in os.listdir (resource_root_dir)]
			for resource_path in resource_list:
				basename = path.basename (resource_path)
				self.write_io_field ('Installing', basename)
				if path.isdir (resource_path):
					resource_dest_dir = path.join (destination_dir, basename)
					if path.exists (resource_dest_dir):
						self.file_system.remove_tree (resource_dest_dir)	
					self.file_system.copy_tree (resource_path, resource_dest_dir)	
				else:
					self.file_system.copy_file (resource_path, destination_dir)

# Implementation

	def __copy_write_exe_manifest (self, bin_dir):
		# Copy Windows manifest file

		manifest_name = self.exe_name + self.Dot_manifest

		if path.exists (self.Manifest_template_xml):
			long_version = self.system.version ().long_string ('.')
			assert long_version.count ('.') == 3, "Windows 10 expects 4 part version numbers"
		#	use XML template in current diretory
			attribute_table = {
				long_version : "version='%s'",
				ise.windows_architecture () : "processorArchitecture='%s'"
			}

			# Read manifest template
			with open (self.Manifest_template_xml, 'r') as infile:
				# Read the entire content of the file
				content = infile.read()

			for value, template in attribute_table.items ():
				attribute = template % (value)
				self.write_io_field ('Manifest entry', attribute)
				content = content.replace (template % ('X'), attribute, 1)

			# Write substituted template
			output_path = path.join (bin_dir, manifest_name)
			with open (output_path, 'w') as outfile: 
				outfile.write (content)
			
			# validate manifest using mt.exe 
			# https://learn.microsoft.com/en-us/windows/win32/sbscs/mt-exe
			if not call (['mt', '-validate_manifest', '-nologo', '-manifest', output_path]) == 0:
				raise SyntaxError ("Failed to validate: " + output_path)

		else:
		# use one in F_code
			manifest_path = path.join (self.code_dir (), manifest_name)
			if path.exists (manifest_path):
				self.file_system.copy_file (manifest_path, bin_dir)

	def __print_permission (self):
		self.write_io_line ("Using %s permissions" % ['normal', 'sudo'][int (self.file_system.sudo)])

	def __put_unique (self, a_list, elem):
		if not elem in a_list:
			a_list.append (elem)

	def __shared_object_libraries (self):
		result = []
		for ecf in self.ecf.libraries:
			for object_path in ecf.c_shared_objects:
				object_path = path.expanded_translated (object_path)
				if path.basename (object_path).startswith ('*.'):
					result.extend (glob (object_path))
				else:
					result.append (object_path)

		return result

	def __write_build_info (self):
		# Write the Eiffel source file `BUILD_INFO' containing version information
		class_name = path.basename (self.build_info_path)
		class_name = (class_name [0: class_name.rfind ('.e')]).swapcase ()

		version = self.system.version ()
		f = open (self.build_info_path, 'w')
		f.write (
			Build_info_class_template.substitute (
				class_name = class_name,
				version = version.compact (),
				build_number = version.build,
				# Assumes unix separator
				installation_sub_directory = self.system.installation_sub_directory ()
			)
		)
		f.close ()

	def __write_launch_script (self, bin_dir):
		# create a Unix launch script for application with LD_LIBRARY_PATH set

		install_bin_dir = path.join (self.system.installation_dir (), 'bin')
		script_path = path.join (bin_dir, self.exe_name + '.sh')
		f = open (script_path, 'w')
		f.write (Launch_script_template % (install_bin_dir, self.exe_name))
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

# end class FREEZE_BUILD

class FINALIZED_BUILD (FREEZE_BUILD):

	Reverse = 'reverse'

# Initialization
	def __init__ (self, ecf, project_py):
		FREEZE_BUILD.__init__ (self, ecf, project_py)
		self.system_root_class_path = self.system.root_class_path ()
		self.preserve_resources = project_py.preserve_resources
		self.file_system.sudo = False

		self.root_class_path = ecf.root_class_path if ecf.root_class_path else self.system_root_class_path

# Access
	def build_type (self):
		return 'F_code'

	def resources_destination (self):
		return path.join (self.Build_dir, ise.platform, 'package')

	def target_steps (self):
		result = self.resources_destination ().split (os.sep) + ['bin', self.exe_name]
		return result

	def compilation_options (self):
		result = ['-finalize']
		if self.compile_C_code ():
			result.append (self.C_compile)
		if self.ecf.keep_assertions:
			result.append (self.Keep_assertions)
		return result

# Status query
	def compile_C_code (self):
		# generate and compile C code
		return True;

# Basic operations
	def compile (self):
		swapped = False
		if not self.root_class_path is self.system_root_class_path:
			self.__swap_root_class ()
			swapped = True

		super (FINALIZED_BUILD, self).compile ()

		if swapped:
			self.__swap_root_class (self.Reverse)

	def post_compilation (self):
		destination = self.resources_destination ()
		self.install_resources_to (destination)
		self.install_executables (destination)

	def install_resources (self):
		self.install_resources_to (self.system.installation_dir ())

# Implementation

	def _wipe_out_f_code (self):
		code_dir = self.code_dir ()
		dir_util.remove_tree (code_dir)
		dir_util.mkpath (code_dir) # Leave an empty F_code directory otherwise EiffelStudio complains

	def __swap_root_class (self, reverse_swap = None):
		# temporarily swap `self.system_root_class_path' with `self.root_class_path'
		# reverse swap if not reverse_swap = None

		root_class_path = self.system_root_class_path
		tmp_path = path.splitext (root_class_path) [0] + '.tmp'
		target_path = self.root_class_path
		if path.dirname (root_class_path) != path.dirname (target_path):
			raise Exception ("Alternative root class must be in same directory as system root class")
		if reverse_swap:
			os.rename (root_class_path, target_path)
			os.rename (tmp_path, root_class_path)
		else:
			# Fix effect of failed compilation
			if path.exists (tmp_path):
				self.__swap_root_class (self.Reverse)

			os.rename (root_class_path, tmp_path)
			os.rename (target_path, root_class_path)

# end class FINALIZED_BUILD

class C_CODE_TAR_BUILD (FINALIZED_BUILD):
# Generates cross-platform Finalized_code.tar

# Access
	def target_steps (self):
		result = self.f_code_tar_steps ()
		return result

# Status query
	def compile_C_code (self):
		# generate but do not compile C code
		return False;

# Basic operations
	def compile (self):
		super (C_CODE_TAR_BUILD, self).compile ()

		tar_path = self.f_code_tar_path ()
		if path.exists (tar_path):
			os.remove (tar_path)
		self.write_io_field ('Archiving to', tar_path)

		tar = ARCHIVE (self.f_code_tar_unix_path ())
		tar.chdir = '/'.join (self.code_dir_steps ()[0:-1])
		tar.append ('F_code')
		self._wipe_out_f_code ()

# end class C_CODE_TAR_BUILD

class FINALIZED_BUILD_FROM_TAR (FINALIZED_BUILD):
# extracts F_code-<platform>.tar and compiles to executable, and then deletes `F_code'
	
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
		
		# only extract if F_code is empty
		#if not os.listdir (self.code_dir ()):
		tar_path = self.f_code_tar_unix_path ()
		tar = ARCHIVE (tar_path)
		tar.chdir = '/'.join (self.code_dir_steps ()[0:-1])
		self.write_io_field ('Extracting', tar_path)
		tar.extract ()

		curdir = path.abspath (os.curdir)
		os.chdir (self.code_dir ())
		ret_code = osprocess.call (['finish_freezing'])
		os.chdir (curdir)

	def post_compilation (self):
		super (FINALIZED_BUILD_FROM_TAR, self).post_compilation ()
		self._wipe_out_f_code ()

# end FINALIZED_BUILD_FROM_TAR

# Manifest constants

Build_info_class_template = Template (
'''note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"

class
	${class_name}

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Version_number: NATURAL = ${version}

	Build_number: NATURAL = ${build_number}

	Installation_sub_directory: DIR_PATH
		once
			Result := "${installation_sub_directory}"
		end

end''')

Launch_script_template = '''#!/usr/bin/env bash
export LD_LIBRARY_PATH="%s"
"$LD_LIBRARY_PATH/%s" $*
'''
