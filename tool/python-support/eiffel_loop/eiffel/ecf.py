#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2024 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "6 Aug 2024"
#	revision: "0.1"

import os, sys

from eiffel_loop.eiffel import ise_environ

from eiffel_loop.os import path
from eiffel_loop import platform

from eiffel_loop.xml.xpath import XPATH_ROOT_CONTEXT
from eiffel_loop.xml.xpath import XPATH_CONTEXT

global ise

ise = ise_environ.shared

def programs_suffix ():
	result = '.exe' if sys.platform == 'win32' else ''
	return result

class SYSTEM_VERSION (object):
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

# end class SYSTEM_VERSION		

class LIBRARY (object):
# Description: ecf library context

	windows = "windows"
	platform_attributes = ['value', 'excluded_value']

# Initialization
	def __init__ (self, ctx):
		self.ctx = ctx
		if not isinstance (ctx, XPATH_CONTEXT):
			raise ValueError ("ctx is not a XPATH_CONTEXT")

		self.platform = platform.name ()

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

# end class LIBRARY

class EXTERNAL_OBJECT (LIBRARY):
# Description: ecf external object

	Custom_value = "condition/custom[@name='%s']/@value"
	Multithreaded_conditions = {
		'concurrency': { 'value' : 'none', 'excluded_value' : 'none' },
		'multithreaded': { 'value' : 'false', 'excluded_value' : 'false' }
	}

# Initialization
	def __init__ (self, ctx):
		LIBRARY.__init__ (self, ctx)

		self.is_multithreaded = True
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

# end class EXTERNAL_OBJECT

class SYSTEM_INFO (object):

	Build_dir = 'build'

# Initialization
	def __init__ (self, root_ctx):
		if not isinstance (root_ctx, XPATH_ROOT_CONTEXT):
			raise ValueError ("root_ctx is not a XPATH_ROOT_CONTEXT")

		self.ctx = root_ctx.context_list ('/system')[0]
		for k, v in self.ctx.attrib_table ().items():
			setattr (self, k, v)
		
		self.platform = platform.name ()

# Access

	def cluster_list (self):
		return self.__new_cluster_list ()

	def exe_name (self):
		result = self.name + '.exe' if platform.is_windows () else self.name
		return result

	def type (self):
		# classic | dotnet
		return self.ctx.attribute ('target[1]/@name')

	def version (self):
		return SYSTEM_VERSION (self.ctx)

	def precompile_path (self):
		result = self.ctx.attribute ('target[1]/precompile/@location')
		if result:
			result = path.expanded_translated (result)
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

# end class SYSTEM_INFO

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

		self.platform = ise_platform if ise_platform else system.platform

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

# end class EIFFEL_CONFIG_FILE


