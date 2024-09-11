#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2021 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 Sep 2024"
#	revision: "3"

import os, subprocess, sys
from os import path
from eiffel_loop.os.environ import REGISTRY_NODE
from eiffel_loop.eiffel import ise_environ

global ise
ise = ise_environ.shared

if sys.platform == "win32":
	import _winreg

def ascii (value):
	return value.encode ('ascii')

class MICROSOFT_COMPILER_OPTIONS (object):

# From "Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" (See notes below)

	Valid_architectures = ['x86', 'x64', 'ia64']

	Valid_build_types = ['Debug', 'Release']

	Valid_compatibility_options = ['2003', '2008', 'vista', 'win7', 'xp']
	
	Valid_compatibility_modes = [
		'Win95', 'Win98', 'WinXP', 'WinXPSP3', 'Vista', 'VistaSP1', 'VistaSP2',
		'Win7', 'Win8', 'Win10', 'NT4SP5', 'Server2003SP1'
	]

# Initialization
	def __init__ (
		self, architecture = 'x64', build_type = 'Release',
				compatibility = 'win7', compatibility_mode = 'Win7'
	):

		# default switches: /win7 /x64 /Release

		self.architecture = architecture
		self.build_type = build_type
		self.compatibility = compatibility
		self.compatibility_mode = compatibility_mode

# Status query
	def is_x86_architecture (self):
		return self.architecture == self.Valid_architectures [0]

# Element change
	def set_architecture (self, architecture):
		assert (architecture in self.Valid_architectures)
		self.architecture = architecture

	def set_build_type (self, build_type):
		assert (build_type in self.Valid_build_types)
		self.build_type = build_type

	def set_compatibility (self, compatibility):
		assert (compatibility in self.Valid_compatibility_options)
		self.compatibility = compatibility

	def set_compatibility_mode (self, compatibility_mode):
		# used to set compatibility mode registry entry value during installation
		# HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers

		assert (compatibility_mode in self.Valid_compatibility_modes)
		self.compatibility_mode = compatibility_mode

# Conversion
	def as_switch_string (self):
		# command switches string

		# Nice trick to put all attributes into a list
		option_list = [
			'/' + opt for opt in self.__dict__.values () if not opt is self.compatibility_mode
		]
		result = ' '.join (option_list)
		return result

#end MICROSOFT_COMPILER_OPTIONS

class MICROSOFT_SDK (object):
	# Compiler SDK
	# Quick help on SetEnv.Cmd and vcvarsall.bat for various SDK versions below

# Constants
	Key_sdk_windows = r'SOFTWARE\Microsoft\Microsoft SDKs\Windows'

	Key_visual_studio = r'SOFTWARE\WOW6432Node\Microsoft\VisualStudio'

	Key_devenv_exe = r'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\devenv.exe'

	Set_compiler_env_bat = 'set_msvc_compiler_environment.bat'

	Step_common7 = 'common7'
	
	Tools_vs_dev_cmd = r"Tools\VsDevCmd.bat"

# Initialization
	def __init__ (self, MSC_options):
		self.MSC_options = MSC_options
		self.local_machine = REGISTRY_NODE (_winreg.HKEY_LOCAL_MACHINE)

		if ise.msvc_version == ise.Default_msvc_version:
			# Default to Windows SDK
			self.sdk_version = self.reg_value (self.Key_sdk_windows, "CurrentVersion")
			key_sdk_tools = path.join (self.Key_sdk_windows, self.sdk_version, 'WinSDKTools')
			bin_dir = self.reg_value (key_sdk_tools, "InstallationFolder")
			self.setenv_cmd = path.join (bin_dir, 'SetEnv.Cmd')

		else:
			self.setenv_cmd = self.vs_dev_cmd_path ()
			if not path.exists (self.setenv_cmd):
				setup_vc_path = path.join (self.Key_visual_studio, ise.msvc_version, 'Setup', 'VC')
				product_dir = self.reg_value (setup_vc_path, 'ProductDir')
				bin_dir = path.join (product_dir, 'bin')
				self.setenv_cmd = path.join (product_dir, 'vcvarsall.bat')
			self.sdk_version = 'v10.0'

# Access
	def compiler_environ (self):
		# table of environment values to configure C compiler
		# captured from output of script: setenv.cmd (MS SDK) OR vcvarsall.bat (VisualStudio)

		result = {}
		arg_str = self.MSC_options.as_switch_string ()
	
		# create script to obtain modified OS environment variables
		f = open (self.Set_compiler_env_bat, 'w')
		f.write ('@echo off\n')
		print 'call "%s" %s\n' % (self.setenv_cmd, arg_str)
		f.write ('call "%s" %s\n' % (self.setenv_cmd, arg_str))
		f.write ('set') # outputs all environment values for parsing
		f.close ()

		# Capture script output
		p = subprocess.Popen([self.Set_compiler_env_bat], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		out, err = p.communicate()
		os.remove (self.Set_compiler_env_bat)
	
		# parse script output
		for line in out.split ('\n'):
			# check if output is help text
			for usage in ['Usage:', 'usage.']:
				if line.find (usage) >= 0:
					print "ERROR Invalid MSC option: " + arg_str
					exit (1)

			pos_equal = line.find ('=') 
			if pos_equal > 0:
				name = line [0:pos_equal]
				value = line [pos_equal + 1:-1]
				# Fixes a problem on Windows for user 'maeda'
				name = ascii (name).upper (); value = ascii (value)
				result [name] = value

		if self.sdk_version == 'v7.1':
			result ['LIB'] = self.lib_v7_1 (result)

		return result

# Status query
	def is_x86_cpu (self):
		return self.MSC_options.is_x86_architecture ()

# Implementation

	def common7_path (self, a_path):
		result = a_path
		while not path.basename (result) == self.Step_common7:
			result = path.dirname (result)

		return result

	def reg_value (self, key_path, name = None):
		self.local_machine.key_path = key_path
		return self.local_machine.value (name)

	def vs_dev_cmd_path (self):
		result = self.reg_value (self.Key_devenv_exe)
		if self.Step_common7 in result:
			# remove double quotes
			if result [0] == '"':
				result = result [1:-1]
			result = path.join (self.common7_path (result), self.Tools_vs_dev_cmd)

		return result

	def lib_v7_1 (self, env_table):
		# Workaround for bug in setenv.cmd (SDK ver 7.1)
		# Add missing path "C:\Program Files\Microsoft SDKs\Windows\v7.1\Lib" to LIB

		lib_set = [p for p in env_table ['LIB'].split (os.pathsep) if p]
		# WINDOWSSDKDIR already has a '\' at the end
		lib_set.append (env_table ['WINDOWSSDKDIR'] + 'Lib')

		return os.pathsep.join (lib_set)

# end class MICROSOFT_SDK

# C:\>"C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd"
# Usage: "Setenv [/Debug | /Release][/x86 | /x64 | /ia64][/vista | /xp | /2003 | /2008 | /win7][-h | /?]"
# 
# 	/Debug   - Create a Debug configuration build environment
# 	/Release - Create a Release configuration build environment

# 	/x86     - Create 32-bit x86 applications
# 	/x64     - Create 64-bit x64 applications
# 	/ia64    - Create 64-bit ia64 applications

# 	/vista   - Windows Vista applications
# 	/xp      - Create Windows XP SP2 applications
# 	/2003    - Create Windows Server 2003 applications
# 	/2008    - Create Windows Server 2008 or Vista SP1 applications
# 	/win7    - Create Windows 7 applications
# 
# Note:
# * Platform(x86/x64/ia64) and PlatformToolSet(v90/v100/WindowsSDK7.1) set in project or solution will over
# * To upgrade VC6 or later projects to VC2010 format use the VCUpgrade.exe tool.
	
		
# C:\>"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
# [ERROR:~nx0] Error in script usage. The correct usage is:
# Syntax:
# 	vcvarsall.bat [arch]
#   or
# 	vcvarsall.bat [arch] [version]
#   or
# 	vcvarsall.bat [arch] [platform_type] [version]
# where :
# 	[arch]: x86 | amd64 | x86_amd64 | x86_arm | x86_arm64 | amd64_x86 | amd64_arm | amd64_arm64
# 	[platform_type]: {empty} | store | uwp
# 	[version] : full Windows 10 SDK number (e.g. 10.0.10240.0) or "8.1" to use the Windows 8.1 SDK.
# 
# The store parameter sets environment variables to support Universal Windows Platform application
# development and is an alias for 'uwp'.
# 
# For example:
# 	vcvarsall.bat x86_amd64
# 	vcvarsall.bat x86_amd64 10.0.10240.0
# 	vcvarsall.bat x86_arm uwp 10.0.10240.0
# 	vcvarsall.bat x86_arm onecore 10.0.10240.0
# 	vcvarsall.bat x64 8.1
# 	vcvarsall.bat x64 store 8.1
# 
# Please make sure either Visual Studio or C++ Build SKU is installed.

# C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC>vcvarsall.bat /?
# Error in script usage. The correct usage is:
#     vcvarsall.bat [option]
# where [option] is: x86 | ia64 | amd64 | x86_amd64 | x86_ia64
# 
# For example:
#     vcvarsall.bat x86_ia64
# 
# C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC>vcvarsall.bat -h
# Error in script usage. The correct usage is:
#     vcvarsall.bat [option]
# where [option] is: x86 | ia64 | amd64 | x86_amd64 | x86_ia64
# 
# For example:
#     vcvarsall.bat x86_ia64
