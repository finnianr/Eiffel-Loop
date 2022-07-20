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

from eiffel_loop.eiffel import ise_environ

from eiffel_loop import osprocess
from eiffel_loop.distutils import dir_util, file_util

from eiffel_loop.os.system import new_file_system

from eiffel_loop.xml.xpath import XPATH_ROOT_CONTEXT
from eiffel_loop.xml.xpath import XPATH_CONTEXT
from eiffel_loop.tar import ARCHIVE

from subprocess import call

global Build_info_class_template, ise

ise = ise_environ.shared

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

		description = ctx.text ("description")
		if description:
			self.description = description
		else:
			self.description = ""

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
	custom_value = "condition/custom[@name='%s']/@value"
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
		value = ctx.attribute (self.custom_value % 'shared')
		if value:
			self.is_shared = value.lower() == 'true'

# Access
	def location (self):
		result = self.ctx.attribute ('@location')
		if result:
			result = result.translate (None , '()')

		return result

	def library (self):
		prefix = ''
		result = self.location ()
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
		value = self.ctx.attribute (self.custom_value % 'copy')
		if value == '$location':
			result.append (expanded_path (self.location ()))
		elif value:
			result.append (expanded_path (value))

		# dependency shared objects (Eg. override/ES-cURL.pecf)
		for i in range (1, 10):
			value = self.ctx.attribute (self.custom_value % ('depends_' + str (i)))
			if value:
				result.append (expanded_path (value))
			else:
				break
	
		return result

# Status query
	def matches_multithreaded (self, platform):
		return self.platform == platform and self.is_multithreaded


class SYSTEM_INFO (object):

	Build_dir = 'build'

# Initialization
	def __init__ (self, root_ctx):
		if not isinstance (root_ctx, XPATH_ROOT_CONTEXT):
			raise ValueError ("root_ctx is not a XPATH_ROOT_CONTEXT")

		self.ctx = root_ctx.context_list ('/system')[0]
		for k, v in self.ctx.attrib_table ().items():
			setattr (self, k, v)
		
		self.platform = platform_name ()

# Access

	def cluster_list (self):
		return self.__new_cluster_list ()

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

	def root_class_name (self):
		return self.ctx.attribute ('target[1]/root[1]/@class')

	def root_class_path (self):
		base_name = self.root_class_name ().swapcase () + '.e'
		for name, location in self.cluster_list ().items ():
			result = path.join (location, base_name)
			if path.exists (result):
				break
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
			if ise.is_32_bit_platform () and os_platform.machine () == 'AMD64':
				suffix = ' (x86)'
			result = path.join ('c:\\Program files' + suffix, installation_sub_directory)
			
		return result

# Basic operations

	def write_version_text (self):
		# Write build/version.txt
		f = open (path.join (self.Build_dir, 'version.txt'), 'w')
		f.write ("%s.%s.%s" % self.version ().tuple_3 ())
		f.close ()

# Implementation
	def __new_cluster_list (self):
		# list of non ISE libraries
		result = {}
		for ctx in self.ctx.context_list ('target[1]/cluster'):
			location = path.normpath (ctx.attribute ("@location"))
			result [ctx.attribute ("@name")] = path.expandvars (location)
		return result

class EIFFEL_CONFIG_FILE (object):

# Initialization
	def __init__ (self, ecf_path, ecf_table = dict (), ise_platform = None):
		self.location = ecf_path
		try:
			ecf_ctx = XPATH_ROOT_CONTEXT (ecf_path, 'ec')

		except KeyError:
			raise KeyError ("Problem namespace prefix: " + ecf_path)

		system = SYSTEM_INFO (ecf_ctx)
		
		self.uuid = system.uuid
		self.name = system.name
		if ise_platform:
			self.platform = ise_platform
		else:
			self.platform = system.platform

		self.keep_assertions = False
		self.root_class_path = None

		self.libraries_table = {self.uuid : self}

		self.precompile_path = None
		top_level = len (ecf_table) == 0
		if top_level:
			self.__set_top_level_properties (system)
			print "\nLibraries:",

		print path.basename (ecf_path) + ',',

		ecf_table [ecf_path] = self

		self.objects_list = self.__new_external_objects_list (ecf_ctx)
		self.external_libs = self.__external_libs ()
		self.c_shared_objects = self.__external_shared_objects ()

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

	def __external_libs (self):
		result = []
		for external in self.objects_list:
			result.append (external.library ())
		return result

	def __external_shared_objects (self):
		# Find shared objects (dll files, jar files, etc) in description field containing "requires:"
		result = []
		for external in self.objects_list:
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
			external = EXTERNAL_OBJECT (ctx)
			if external.matches_multithreaded (self.platform):
				result.append (external)
		return result

class FREEZE_BUILD (object):
	
	Build_dir = 'build'
	C_compile = '-c_compile'
	Freeze = '-freeze'
	Keep = '-keep'

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

# Status query
	

# Basic operations
	def install_resources (self):
		installation_dir = self.system.installation_dir ()
		preserve_list = list ()
		if self.preserve_resources:
			for resource_path in self.preserve_resources:
				resource_path_abs = path.join (installation_dir, resource_path)
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
		self.write_io (' '.join (cmd) + '\n')
		ret_code = call (cmd)

	def post_compilation (self):
		self.install_resources_to (self.resources_destination ())

	def write_io (self, str):
		sys.stdout.write (str)

# Implementation
	def __print_permission (self):
		self.write_io ("Using %s permissions\n" % ['normal', 'sudo'][int (self.file_system.sudo)])

	def install_executables (self, destination_dir):
		self.write_io ('Installing executables in: %s\n' % destination_dir)
		self.__print_permission ()

		bin_dir = path.join (destination_dir, 'bin')
		if not path.exists (bin_dir):
			self.file_system.make_path (bin_dir)
		
		# Copy executable including possible Windows 7 manifest file
		for exe_path in glob (path.join (self.code_dir (), self.exe_name + '*')):
			self.file_system.copy_file (exe_path, bin_dir)

		self.write_io ('Copying shared object libraries\n')
		shared_objects = self.__shared_object_libraries ()
		for so in shared_objects:
			self.file_system.copy_file (so, bin_dir)

		if shared_objects and is_platform_unix ():
			install_bin_dir = path.join (self.system.installation_dir (), 'bin')
			script_path = path.join (bin_dir, self.exe_name + '.sh')
			f = open (script_path, 'w')
			f.write (launch_script_template % (install_bin_dir, self.exe_name))
			f.close ()

	def install_resources_to (self, destination_dir):
		self.write_io ('Installing resources in: %s\n' % destination_dir)
		self.__print_permission ()

		if not path.exists (destination_dir):
			self.file_system.make_path (destination_dir)
		resource_root_dir = "resources"
		if path.exists (resource_root_dir):
			resource_list = [path.join (resource_root_dir, name) for name in os.listdir (resource_root_dir)]
			for resource_path in resource_list:
				basename = path.basename (resource_path)
				self.write_io ('Installing %s\n' % basename)
				if path.isdir (resource_path):
					resource_dest_dir = path.join (destination_dir, basename)
					if path.exists (resource_dest_dir):
						self.file_system.remove_tree (resource_dest_dir)	
					self.file_system.copy_tree (resource_path, resource_dest_dir)	
				else:
					self.file_system.copy_file (resource_path, destination_dir)

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

class FINALIZED_BUILD (FREEZE_BUILD):

	Reverse = 'reverse'

# Initialization
	def __init__ (self, ecf, project_py):
		FREEZE_BUILD.__init__ (self, ecf, project_py)
		self.system_root_class_path = self.system.root_class_path ()
		self.preserve_resources = project_py.preserve_resources
		self.file_system.sudo = False

		if ecf.root_class_path:
			self.root_class_path = ecf.root_class_path
		else:
			self.root_class_path = self.system_root_class_path

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

# end FINALIZED_BUILD

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
		self.write_io ('Archiving to: %s\n' % tar_path)

		tar = ARCHIVE (self.f_code_tar_unix_path ())
		tar.chdir = '/'.join (self.code_dir_steps ()[0:-1])
		tar.append ('F_code')
		self._wipe_out_f_code ()

# end C_CODE_TAR_BUILD

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
		self.write_io ('Extracting: %s\n' % tar_path)
		tar.extract ()

		curdir = path.abspath (os.curdir)
		os.chdir (self.code_dir ())
		ret_code = osprocess.call (['finish_freezing'])
		os.chdir (curdir)

	def post_compilation (self):
		super (FINALIZED_BUILD_FROM_TAR, self).post_compilation ()
		self._wipe_out_f_code ()

# end FINALIZED_BUILD_FROM_TAR

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

launch_script_template = '''#!/usr/bin/env bash
export LD_LIBRARY_PATH="%s"
"$LD_LIBRARY_PATH/%s" $*
'''
