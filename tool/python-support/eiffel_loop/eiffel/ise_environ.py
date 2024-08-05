#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "7 Nov 2021"
#	revision: "0.1"

import os
import platform as os_platform

from eiffel_loop.os import path
from eiffel_loop.os import environ as os_environ
from eiffel_loop import platform as system

class ISE_ENVIRON (object):
	# Constants
	Default_msvc_version = '10.0'

	Key_c_compiler = 'ISE_C_COMPILER'
	Key_platform = 'ISE_PLATFORM'
	Key_version = 'ISE_VERSION'

	Platform_32_bit = 'windows'
	Platform_64_bit = 'win64'

	# Path keys
	Key_precomp = 'ISE_PRECOMP'
	Key_eiffel = 'ISE_EIFFEL'
	Key_library = 'ISE_LIBRARY'

	Path_keys = [Key_eiffel, Key_library, Key_precomp]

	def __init__ (self):
		environ = os.environ
		self.msvc_version = self.Default_msvc_version
		self.platform = environ [self.Key_platform]
		self.library = environ [self.Key_library]
		self.version = environ [self.Key_version]

		self.set_dir_paths ()
		self.set_c_compiler ()

	# Access
	def spec_build_dir (self):
		return path.join ('spec', self.platform)

	# Status query

	def compiling_x86_on_x64 (self):
		# true if compiling a 32 bit application on a 64 bit machine

		result = self.is_32_bit_platform () and os_platform.machine () == 'AMD64'
		return result

	def is_32_bit_platform (self):
		return self.platform == self.Platform_32_bit

	def is_64_bit_platform (self):
		return self.platform == self.Platform_64_bit

	# Element change

	def update (self):
		environ = os.environ
		print "updating for", environ [self.Key_platform]

		self.platform = environ [self.Key_platform]
		self.version = environ [self.Key_version]
		self.set_c_compiler ()

		is_x86_environ = self.platform == self.Platform_32_bit

		for key, template in os_environ.user_templates ().items ():
			if key in self.Path_keys:
				if is_x86_environ:
					template = path.files_x86 (template)

				environ [key] = path.expandvars (template)

		self.set_dir_paths ()

	def set_c_compiler (self):
		if os.environ.has_key (self.Key_c_compiler):
			self.c_compiler = os.environ [self.Key_c_compiler]
		elif system.is_unix ():
			self.c_compiler = 'gcc'
		else:
			self.c_compiler = 'msc'

		self.set_msvc_version ()

	def set_dir_paths (self):
		environ = os.environ
		self.eiffel = environ [self.Key_eiffel]
		self.precomp = environ [self.Key_precomp]

		if os.environ.has_key (self.Key_library):
			self.library = environ [self.Key_library]
		else:
			self.library = self.eiffel
			environ [self.Key_library] = self.library

	def set_archictecture (self, bit_count):
		if bit_count == 32:
			self.platform = self.Platform_32_bit
		else:
			self.platform = self.Platform_64_bit

		os.environ [self.Key_platform] = self.platform

	def set_msvc_version (self):
		self.msvc_version = self.Default_msvc_version
		# parse 'msc' or 'msc_vc140'
		parts = self.c_compiler.split ('_')
		if len (parts) == 2:
			vc = parts [1]
			if vc.startswith ('vc'):
				# vc140 -> 14.0
				vc_version = vc [2:]
				array = bytearray (vc_version)
				array.insert (len (array) - 1, '.')
				self.msvc_version = str (array)

# end class ISE_ENVIRON

# globally shared instance
shared = ISE_ENVIRON ()
