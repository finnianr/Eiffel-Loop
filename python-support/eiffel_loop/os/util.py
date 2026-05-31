#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 May 2026"
#	revision: "0.1"

import os

if os.name == 'nt':
	import winreg as _winreg

def os_imp (a_type, *args, **kwargs):
	# Create OS specific implementation instance of class conforming to type 'a_type'
	# Raise NotImplementedError if class with expected name prefix 'WINDOWS_' or 'POSIX_'
	# is not defined
	
	prefix = 'WINDOWS_' if os.name == 'nt' else 'POSIX_'
	
	result = None
	
	for cls in a_type.__subclasses__():
		if cls.__name__.startswith (prefix):
			result = cls (*args, **kwargs)
			break
			
	if result:
		return result
	else:
		raise NotImplementedError (prefix + a_type.__name__)
		
class REGISTRY_NODE:

# Initialization
	def __init__ (self, tree_key, key_path = None):
		self.tree_key = tree_key
		self.key_path = key_path

# Access
	def ascii_value (self, name = None):
		return self.value (name).encode ('ascii')

	def value (self, name = None):
		# if name is None, then default value is returned
		try:
			key = _winreg.OpenKey (self.tree_key, self.key_path, 0, _winreg.KEY_READ)
		except WindowsError:
			key = None

		if key:
			result = _winreg.QueryValueEx (key, name)[0]
			_winreg.CloseKey (key)
		else:
			result = ''

		return result

	def value_table (self, encoding = None):
		result = dict ()
		try:
			key = _winreg.OpenKey (self.tree_key, self.key_path, 0, _winreg.KEY_READ)
		except WindowsError:
			key = None

		if key:
			for i in range (0, _winreg.QueryInfoKey (key)[1], 1):
				nvp = _winreg.EnumValue(key, i)
				name = nvp [0]; value = nvp [1]
				if encoding:
					result [name.encode (encoding)] = value.encode (encoding)
				else:
					result [name] = value

			_winreg.CloseKey (key)
		
		return result

# Basic operations
	def set_expandable_value (self, value, expandable = False):
		self.set_value (value, True)
 
	def set_value (self, value, expandable = False):
		key = _winreg.CreateKeyEx (self.tree_key, self.key_path, 0, _winreg.KEY_ALL_ACCESS)
		if key:
			if expandable:
				_winreg.SetValueEx (key, '', 0, _winreg.REG_EXPAND_SZ, value)
			else:
				_winreg.SetValue (key, '', _winreg.REG_SZ, value)
				
			_winreg.CloseKey (key)
		else:
			raise Exception ("Registry path not found: " + key_path)

# end class REGISTRY_NODE
		

