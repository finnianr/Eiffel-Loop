#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.1"

import os, subprocess, sys
from os import path

if sys.platform == "win32":
	import _winreg

class MICROSOFT_SDK (object):
	# Compiler SDK
	# Quick help on SetEnv.Cmd and vcvarsall.bat below

# Initialization
	def __init__ (self, c_compiler, MSC_options):
		vc_version = 0
		self.sdk_version = 0
		self.MSC_options = MSC_options

		self.target_cpu = None
		for cpu in self.Architecture_options:
			if cpu in MSC_options:
				self.target_cpu = cpu
				break

		if not self.target_cpu:
			raise Exception ("Invalid architecture switch in MSC_options")
			exit (1)

		# parse 'msc' or 'msc_vc140'
		parts = c_compiler.split ('_')
		if len (parts) == 2:
			vc = parts [1]
			if vc.startswith ('vc'):
				# vc140 -> 14.0
				vc_version = int (vc[2:])
				array = bytearray (str (vc_version))
				array.insert (len (array) - 1, '.')
				self.sdk_version = str (array)
				# strip fowardslash for vcvarsall.bat and ignore other options
				self.MSC_options = [self.target_cpu.lstrip ('/')]

		if vc_version:
			# Use Visual Studio
			setup_vc_path = path.join (self.Key_visual_studio, self.sdk_version, 'Setup', 'VC')
			product_dir = self.reg_value (setup_vc_path, 'ProductDir')
			self.tools_dir = path.join (product_dir, 'bin')
			self.setenv_cmd = path.join (product_dir, 'vcvarsall.bat')
		else:
			# Default to Windows SDK
			self.sdk_version = self.reg_value (self.Key_sdk_windows, "CurrentVersion")
			key_sdk_tools = path.join (self.Key_sdk_windows, self.sdk_version, 'WinSDKTools')
			self.tools_dir = self.reg_value (key_sdk_tools, "InstallationFolder")
			self.setenv_cmd = path.join (self.tools_dir, 'SetEnv.Cmd')

# Access

	def compiler_environ (self):
		# table of environment values to configure C compiler
		# captured from output of script: setenv.cmd (MS SDK) OR vcvarsall.bat (VisualStudio)

		result = {}
		arg_str = ' '.join (self.MSC_options)
	
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
			pos_equal = line.find ('=') 
			if pos_equal > 0:
				name = line [0:pos_equal]
				value = line [pos_equal + 1:-1]
				# Fixes a problem on Windows for user maeda
				name = name.encode ('ascii'); value = value.encode ('ascii')
				result [name.upper ()] = value

		# Workaround for bug in setenv.cmd (SDK ver 7.1)
		# Add missing path "C:\Program Files\Microsoft SDKs\Windows\v7.1\Lib" to LIB

		lib_path = result ['LIB']
		std_lib_dir = result ['WINDOWSSDKDIR'] + 'Lib' # WINDOWSSDKDIR already has a '\' at the end
		if not std_lib_dir in lib_path.split (';'):
			result ['LIB'] = (';').join ([lib_path.rstrip (';'), std_lib_dir])

		return result

#Status query
	def is_x86_cpu (self):
		result = self.target_cpu == self.Architecture_options [0]
		return result

# Implemenation

	def reg_value (self, key_path, name):
		key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, key_path, 0, _winreg.KEY_READ)
		result = _winreg.QueryValueEx (key, name)[0]
		_winreg.CloseKey (key)
		return result

# Constants
	Architecture_options = ['/x86', '/x64'] #SetEnv.Cmd switches

	Key_sdk_windows = r'SOFTWARE\Microsoft\Microsoft SDKs\Windows'

	Key_visual_studio = r'SOFTWARE\WOW6432Node\Microsoft\VisualStudio'

	Set_compiler_env_bat = 'set_msvc_compiler_environment.bat'


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
