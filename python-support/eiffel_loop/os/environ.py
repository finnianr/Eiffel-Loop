#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 May 2026"
#	revision: "0.2"

import os, platform, sys, subprocess, re, sysconfig

from os import path

from .util import *

if os.name == 'nt':
	import winreg as _winreg

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

def print_path ():
	# print system path
	print()
	key = 'PATH'
	print(key + ':')
	for part in os.environ [key].split (os.pathsep):
		print('  ', part)
	print()
	
# CLASSES

class G_SETTINGS:

	def __init__ (self, key: str) -> None:
		self.key = key

	def get (self, setting: str) -> str:
		result = subprocess.run (
			["gsettings", "get", self.key, setting], capture_output=True, text=True, check=True,
		)
		return result.stdout.strip ()

	def set (self, setting: str, value: str) -> None:
		subprocess.run (
			["gsettings", "set", self.key, setting, value], check=True,
		)
	print (f"Setting {setting} to {value}")

	def set_font_size (self, setting: str, size: int) -> None:
		font_name = self.get (setting)
		resized = font_name [:font_name.rfind (' ')] + f' {size}'
		self.set (setting, resized)

class ENVIRONMENT:

# Constants
	Env_eiffel_loop = 'EIFFEL_LOOP'
	Eiffel_loop = 'Eiffel-Loop'

# Status query

	def command_exists (self, command, shell = False):
		fnull_path = path.join (self.temp_dir (), 'python-null.txt')
		FNULL = open (fnull_path, 'w')
		try:
			result = subprocess.call (command, stdout=FNULL, stderr=FNULL, shell = shell) == 0
		except Exception as e:
			result = False
		FNULL.close ()
		os.remove (fnull_path)
		return result

# Access
	def eiffel_loop_dir (self):
		if self.Env_eiffel_loop in os.environ:
			result = os.environ [self.Env_eiffel_loop]
		else:
			result = path.abspath (os.curdir)
			if os.sep + self.Eiffel_loop in result:
				while not path.basename (result).startswith (self.Eiffel_loop):
					result = path.dirname (result)
			else:
				result = None

		return result

	def jdk_home (self):
		pass

	def python3_home (self):
		return path.dirname (path.realpath (sys.executable))

	def python3_lib_name (self):
		return path.basename (self.python3_include ())

	def python3_include (self):
		return sysconfig.get_path ("include")

	def system_path (self):
		# The search path before addition of user modifications in either .profile (Unix)
		# or User Environment path (Windows)
		pass

	def temp_dir (self):
		pass

	def user_path (self):
		# The user additions to search path from .profile (Unix) or User Environment path (Windows)
		pass

	def user_templates (self):
		# user environment templates
		pass
	
class WINDOWS_ENVIRONMENT (ENVIRONMENT):

	def jdk_home (self):
		software_path = r'SOFTWARE\JavaSoft\Java Development Kit'
		try:
			dev_kit = REGISTRY_NODE (_winreg.HKEY_LOCAL_MACHINE, software_path)
			jdk_version = dev_kit.value ("CurrentVersion")
		
			dev_kit.key_path = path.join (software_path, jdk_version)
			result = dev_kit.ascii_value ("JavaHome")
		
		except WindowsError as err:
			result = 'Unknown'

		return result

	def system_path (self):
		# The search path before addition of user modifications in either .profile (Unix)
		# or User Environment path (Windows)
		result = None
		environment_path = r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
		try:
			manager_environ = REGISTRY_NODE (_winreg.HKEY_LOCAL_MACHINE, environment_path)
			result = manager_environ.ascii_value ("Path")

		except WindowsError as err:
			result = None

		return result

	def temp_dir (self):
		return os.environ ['TEMP']

	def user_path (self):
		# The user additions to search path from .profile (Unix) or User Environment path (Windows)
		result = None
		environment_path = r'Environment'
		try:
			user_environ = REGISTRY_NODE (_winreg.HKEY_CURRENT_USER, environment_path)
			result = user_environ.ascii_value ("Path")

		except WindowsError as err:
			result = None

		return result

	def user_templates (self):
		# user environment templates
		result = dict ()
		environment_path = r'Environment'
		try:
			user_environ = REGISTRY_NODE (_winreg.HKEY_CURRENT_USER, environment_path)
			result = user_environ.value_table ('ascii')
	
		except WindowsError as err:
			print("Error", err)
		
		return result

class POSIX_ENVIRONMENT (ENVIRONMENT):
	def jdk_home (self):
		result = None
		properties = subprocess.run(
			["java", "-XshowSettings:properties", "-version"], capture_output=True, text=True
		)
		match = re.search(r'java\.home\s*=\s*(.+)', properties.stderr)
		if match:
			result = match.group(1).strip()
		
		return result

	def system_path (self):
		# The search path before addition of user modifications in either .profile (Unix)
		# or User Environment path (Windows)
		return os.environ ['SYSTEM_PATH']

	def temp_dir (self):
		return '/tmp'

	def user_path (self):
		# The user additions to search path from .profile (Unix) or User Environment path (Windows)
		return os.environ ['USER_PATH']

	def user_templates (self):
		# user environment templates
		return bash_profile_table ()


