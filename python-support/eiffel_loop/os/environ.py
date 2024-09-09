#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 July 2011"
#	revision: "0.1"

import os, platform, sys, imp, subprocess
from os import path

if sys.platform == 'win32':
	import _winreg

def print_path ():
	# print system path
	print
	key = 'PATH'
	print key + ':'
	for part in os.environ [key].split (os.pathsep):
		print '  ', part
	print 

class REGISTRY_NODE (object):

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

def python_home_dir ():
	return os.path.dirname (os.path.realpath (sys.executable))

def bash_profile_table ():
	# return dictionary of exported environment up SYSTEM_PATH
	result = dict ()
	f = open (path.expandvars ('$HOME/.profile'), 'r')
	for line in f:
		if line.startswith ('export SYSTEM_PATH'):
			break
		index_eq = line.find ('=')
		if index_eq > 0 and line.startswith ('export'):
			name = line [line.find (' ') + 1:index_eq]
			value = (line [(index_eq + 1):]).strip ()
			result [name] = value

	return result

def eiffel_loop_dir ():
	env_eiffel_loop = 'EIFFEL_LOOP'
	eiffel_loop = 'Eiffel-Loop'
	if env_eiffel_loop in os.environ:
		result = os.environ [env_eiffel_loop]
	else:
		result = path.abspath (os.curdir)
		if os.sep + eiffel_loop in result:
			while not path.basename (result).startswith (eiffel_loop):
				result = path.dirname (result)	
		else:
			result = None

	return result

def python_dir_name ():
	if os.name == 'posix':
		version_tuple = platform.python_version_tuple()
		result = 'python' + version_tuple[0] + '.' + version_tuple[1]
	else:
		result = path.basename (python_home_dir ())
		
	return result

def user_path ():
	# The user additions to search path from .profile (Unix) or User Environment path (Windows)
	result = None
	if sys.platform == 'win32':
		environment_path = r'Environment'
		try:
			user_environ = REGISTRY_NODE (_winreg.HKEY_CURRENT_USER, environment_path)
			result = user_environ.ascii_value ("Path")
		
		except (WindowsError), err:
			result = None
	else:
		result = os.environ ['USER_PATH']

	return result


def system_path ():
	# The search path before addition of user modifications in either .profile (Unix)
	# or User Environment path (Windows)
	result = None
	if sys.platform == 'win32':
		environment_path = r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
		try:
			manager_environ = REGISTRY_NODE (_winreg.HKEY_LOCAL_MACHINE, environment_path)
			result = manager_environ.ascii_value ("Path")
		
		except (WindowsError), err:
			result = None
	elif os.name == 'posix':
		result = os.environ ['SYSTEM_PATH']

	return result
	
def jdk_home ():
	if sys.platform == 'win32':
		software_path = r'SOFTWARE\JavaSoft\Java Development Kit'
		try:
			dev_kit = REGISTRY_NODE (_winreg.HKEY_LOCAL_MACHINE, software_path)
			jdk_version = dev_kit.value ("CurrentVersion")
		
			dev_kit.key_path = path.join (software_path, jdk_version)
			result = dev_kit.ascii_value ("JavaHome")
		
		except (WindowsError), err:
			result = 'Unknown'

	elif os.name == 'posix':
		result = None
		jvm_dir = '/usr/lib/jvm'
		for name in os.listdir (jvm_dir):
			result = path.join (jvm_dir, name)
			if path.isdir (result) and path.exists (path.join (result, 'jre/lib')):
				break
			else:
				result = None
		
	return result

def temp_dir ():
	if sys.platform == 'win32':
		result = os.environ ['TEMP']
	else:
		result = '/tmp'
	return result

def command_exists (command, shell = False):
	fnull_path = path.join (temp_dir (), 'python-null.txt')
	FNULL = open(fnull_path, 'w')
	try:
		result = subprocess.call (command, stdout=FNULL, stderr=FNULL, shell = shell) == 0
	except (Exception), e:
		result = False
	FNULL.close ()
	os.remove (fnull_path)
	return result

def user_templates ():
	# user environment templates
	result = dict ()
	if sys.platform == 'win32':
		environment_path = r'Environment'
		try:
			user_environ = REGISTRY_NODE (_winreg.HKEY_CURRENT_USER, environment_path)
			result = user_environ.value_table ('ascii')
	
		except (WindowsError), err:
			print "Error", err
	elif os.name == 'posix':
		result = bash_profile_table ()
	
	return result

		

