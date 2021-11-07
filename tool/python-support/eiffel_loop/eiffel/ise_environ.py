#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "7 Nov 2021"
#	revision: "0.1"

import os

from eiffel_loop.os import path
from eiffel_loop.os import environ as os_environ
from eiffel_loop import platform as system

class ISE_ENVIRON (object):
	# Constants
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
		self.platform = environ [self.Key_platform]
		self.library = environ [self.Key_library]
		self.version = environ [self.Key_version]

		self.set_dir_paths ()
		self.set_c_compiler ()

	# Access
	def spec_build_dir (self):
		return path.join ('spec', self.platform)

	# Status query

	def is_32_bit_platform ():
		return self.platform == self.Platform_32_bit

	def is_64_bit_platform ():
		return self.platform == self.Platform_64_bit

	# Element change

	def update (self):
		environ = os.environ
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

# end class ISE_ENVIRON

# globally shared instance
shared = ISE_ENVIRON ()
