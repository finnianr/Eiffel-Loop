#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2024 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "6 Aug 2024"
#	revision: "0.1"

import os, sys
from glob import glob
from string import Template

from eiffel_loop.eiffel import ise_environ
from eiffel_loop.os import env as os_env
from eiffel_loop.os import path
from eiffel_loop import platform

from eiffel_loop.xml.xpath import XPATH_ROOT_CONTEXT
from eiffel_loop.xml.xpath import XPATH_CONTEXT

global ise

ise = ise_environ.shared

def programs_suffix ():
	result = '.exe' if sys.platform == 'win32' else ''
	return result
	
def node_description (ctx):
	result = ctx.text ("description")
	if not result:
		result = ''
	return result

class SYSTEM_VERSION:
# Description: ecf version information


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

	def long_string (self, separator = ' build '):
		result = self.short_string () + separator + self.build
		return result

	def short_string (self):
		result = '.'.join ([self.major, self.minor, self.release])
		return result

	def compact (self):
		return "%02d_%02d_%02d" % (int (self.major), int (self.minor), int (self.release))

# end SYSTEM_VERSION		

class LIBRARY:
# Description: ecf library context

	windows = "windows"
	platform_attributes = ['value', 'excluded_value']

# Initialization
	def __init__ (self, ctx):
		self.ctx = ctx
		if not isinstance (ctx, XPATH_CONTEXT):
			raise ValueError ("ctx is not a XPATH_CONTEXT")

		self.platform = platform.name ()

		self.description = node_description (ctx)

		for name in self.platform_attributes:
			value = ctx.attribute ("condition/platform/@" + name)
			if value:
				if name.startswith ('excluded'):
					if value == self.platform:
						self.platform = platform.opposing (value)
				else:
					self.platform = value
				break

# Access	
	def location (self):
		result = self.ctx.attribute ('@location')
		return result

	def expanded_location (self, ecf_path):
		result = path.expanded_translated (self.location ())
		if not path.isabs (result):
			result = path.normpath (path.join (path.dirname (ecf_path), result))
		return result

	def is_ise (self):
		return self.location ().startswith ('$ISE_')

# end LIBRARY

class EXTERNAL_OBJECT (LIBRARY):
# Description: ecf external object

	Custom_value = "condition/custom[@name='%s']/@value"
	Multithreaded_conditions = {
		'concurrency': { 'value' : 'none', 'excluded_value' : 'none' },
		'multithreaded': { 'value' : 'false', 'excluded_value' : 'false' }
	}

# Initialization
	def __init__ (self, ctx, export_table):
		LIBRARY.__init__ (self, ctx)

		self.is_multithreaded = True
		self.export_table = export_table
		done = False
		for name, table in self.Multithreaded_conditions.items ():
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
		value = ctx.attribute (self.Custom_value % 'shared')
		if value:
			self.is_shared = value.lower() == 'true'

# Access
	def location (self):
		result = self.ctx.attribute ('@location')
		if result:
			result = result.translate (str.maketrans ('', '', '()'))
			result = path.expanded (result, self.export_table)
				
		else:
			raise KeyError ("%s does not have @location" % self.ctx.name ())

		return result

	def library (self):
		prefix = ''
		result = self.location ()
		if result:
			for part in result.split():
				lib = part.strip()
				if lib.startswith ('-L'):
					prefix = lib [2:]
					prefix = prefix.strip ('"')
				else:
					if prefix:
						result = path.expanded_translated (path.join (prefix, 'lib%s.a' % lib [2:]))
					elif lib.startswith ('-l'):
						result = lib
					else:
						result = path.expanded_translated (lib)
		return result

	def shared_libraries (self):
		result = []
		value = self.ctx.attribute (self.Custom_value % 'copy')
		if value == '$location':
			result.append (path.expanded_translated (self.location ()))
		elif value:
			result.append (path.expanded_translated (value))

		# dependency shared objects (Eg. override/ES-cURL.pecf)
		for i in range (1, 10):
			value = self.ctx.attribute (self.Custom_value % ('depends_' + str (i)))
			if value:
				result.append (path.expanded_translated (value))
			else:
				break
	
		return result

# Status query
	def matches_multithreaded (self, platform):
		result = self.platform == platform and self.is_multithreaded
		return result

# end EXTERNAL_OBJECT

class SYSTEM_INFO:

	Build_dir = 'build'

# Initialization
	def __init__ (self, root_ctx):
		if not isinstance (root_ctx, XPATH_ROOT_CONTEXT):
			raise ValueError ("root_ctx is not a XPATH_ROOT_CONTEXT")

		self.ctx = root_ctx.new_context ('/system')
		for k, v in self.ctx.attrib_table ().items():
			setattr (self, k, v)
			
		self.target_ctx = self.ctx.new_context ('target')
		
		self.platform = platform.name ()

# Access

	def cluster_list (self):
		return self.__new_cluster_list ()

	def exe_name (self):
		result = self.name + '.exe' if platform.is_windows () else self.name
		return result

	def type (self):
		# classic | dotnet
		return self.target_ctx.attribute ('@name')

	def version (self):
		return SYSTEM_VERSION (self.ctx)

	def precompile_path (self):
		result = self.target_ctx.attribute ('precompile/@location')
		if result:
			result = path.expanded_translated (result)
		return result

	def root_class_name (self):
		return self.target_ctx.attribute ('root[1]/@class')

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
		if platform.is_unix ():
			result = path.join ('/opt', installation_sub_directory)
		else:
			# In case you are compiling a 32 bit version on a 64 bit machine.
			suffix = ' (x86)' if ise.compiling_x86_on_x64 () else ''

			result = path.join ('c:\\Program files' + suffix, installation_sub_directory)
			
		return result

# Basic operations

	def write_version_text (self):
		# Write build/version.txt
		f = open (path.join (self.Build_dir, 'version.txt'), 'w')
		f.write (self.version ().short_string ())
		f.close ()

# Implementation
	def __new_cluster_list (self):
		# list of non ISE libraries
		result = {}
		for ctx in self.target_ctx.context_list ('cluster'):
			location = path.normpath (ctx.attribute ("@location"))
			result [ctx.attribute ("@name")] = path.expandvars (location)
		return result

# end SYSTEM_INFO

class EIFFEL_CONFIG_FILE:

# Constants
	Export_tag = 'export:'
	Empty_dict = dict ()

# Initialization
	def __init__ (self, ecf_path, ecf_table = dict (), ise_platform = None):
		self.location = ecf_path
		try:
			system = SYSTEM_INFO (XPATH_ROOT_CONTEXT (ecf_path, 'ec'))

		except KeyError:
			raise KeyError ("Problem namespace prefix: " + ecf_path)
		
		self.uuid = system.uuid
		self.name = system.name
		self.target_ctx = system.target_ctx
		self.export_table = self.__new_export_table ()

		self.platform = ise_platform if ise_platform else system.platform

		self.keep_assertions = False
		self.root_class_path = None

		self.libraries_table = {self.uuid : self}

		self.precompile_path = None
		top_level = len (ecf_table) == 0
		if top_level:
			self.__set_top_level_properties (system)
			print("\nLibraries:", end=' ')

		print (path.basename (ecf_path) + ',', end=' '),

		ecf_table [ecf_path] = self

		self.objects_list = self.__new_external_objects_list ()
		self.external_libs = self.__external_libs ()
		self.c_shared_objects = self.__external_shared_objects ()

		for library in self.__new_library_list ():
			location = library.expanded_location (ecf_path)

			# prevent infinite recursion for circular references
			if location in ecf_table:
				ecf = ecf_table [location]
			else:
				# Recurse ecf file
				ecf = EIFFEL_CONFIG_FILE (location, ecf_table)

			self.libraries_table [ecf.uuid] = ecf
			for uuid in ecf.libraries_table:
				self.libraries_table [uuid] = ecf.libraries_table [uuid]

		if top_level:
			self.libraries = self.libraries_table.values ()
			for library in self.libraries: 
				for var, export_path in library.export_table.items ():
					if var in self.export_table:
						if export_path != self.export_table [var]:
							msg_template = "Differing values for export variable '%s'\n\t1. %s\n\t2. %s"
							raise ValueError (msg_template % (var, export_path, self.export_table [var]))
					else:
						self.export_table [var] = export_path

			print('')
			print('')
			
# Basic operations

	def set_export_paths (self):
		# Export C/C++ library paths to OS environ
		
		if self.export_table:
			print ('Export C/C++ library paths to OS environ')
			for name in sorted (self.export_table.keys ()):
				export_path = self.export_table [name]
				print (name + " =", export_path)
				os.environ [name] = export_path
			print('')

	def print_export_path_dict (self, dict_name):
		# print a dictionary manifest for `self.export_table' like the following example:
		# 	c_names = {
		# 		'ID3_LIB' : 'id3lib',
		# 		'LIB_ID3TAG' : 'libid3tag'
		# 	}		
		
		if self.export_table:
			print ("%s = {" % dict_name)
			for name in sorted (self.export_table.keys ()):
				export_path = self.export_table [name]
				print ("\t'%s' : '%s'," % (name, path.basename (export_path)))
			print ('}')

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

	def __new_export_table (self):
		# list of export paths defined in target[1]/description
		# Used for C/C++ library/include paths.

		# Example from ID3-tags.pecf:
		#	target:
		#		name = EL_id3_tag
		#		description:
		#			"""
		#				export:
		#					ID3_LIB = $EIFFEL/external/C++/id3lib*
		#					LIB_ID3TAG = $EIFFEL/external/C/libid3tag*
		#			"""
		
		line_list = node_description (self.target_ctx).split ('\n')
		try:
			i = line_list.index (self.Export_tag)
			result = dict ()
			for line in line_list [i + 1:]:
				nv_pair = line.split ('=')
				if len (nv_pair) == 2:
					name = nv_pair [0].strip()
					if not name in os.environ:
						result [name] = self.__new_expanded_export (result, name, nv_pair [1].strip())
		except ValueError:
			result = self.Empty_dict
					
		return result

	def __new_expanded_export (self, export_table, name, a_path):
		# expanded export path `a_path'
		if a_path.startswith ('os_env.'):
			result = eval (a_path)
		else:
			result = path.expanded (a_path)
		
		if result [-1] == '*':
			path_list = glob (path.expanded (result))
			if len (path_list) == 1:
				result = path_list [0]
			else:
				raise ValueError ("Only one %s path should match wildcard: " % (name) + a_path)
				
		if '$' in result:
			result = Template (result).safe_substitute (export_table)
				
		if not path.exists (result) and path.isabs (result):
			raise FileNotFoundError (name + ": " + result)
			
		return result					

	def __new_library_list (self):
		# list of non ISE libraries
		result = []
		for ctx in self.target_ctx.context_list ('library'):
			library = LIBRARY (ctx)
			#print library.location (), library.platform
			if not library.is_ise () and library.platform == self.platform:
				result.append (library)
		return result

	def __new_external_objects_list (self):
		result = []
		for ctx in self.target_ctx.context_list ('external_object'):
			external = EXTERNAL_OBJECT (ctx, self.export_table)
			if external.matches_multithreaded (self.platform):
				result.append (external)
		return result

# end EIFFEL_CONFIG_FILE


