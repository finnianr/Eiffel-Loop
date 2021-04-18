#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.1"

import os, subprocess, sys

from distutils import dir_util
from distutils import file_util
from os import path
from subprocess import call

if sys.platform == "win32":
	import _winreg

def microsoft_sdk_path ():
	# Better not to rely on MSDKBIN environ var
	key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, r'SOFTWARE\Microsoft\Microsoft SDKs\Windows', 0, _winreg.KEY_READ)
	result = _winreg.QueryValueEx (key, "CurrentInstallFolder")[0]
	return result

def microsoft_visual_studio_path ():
	# Better not to rely on MSDKBIN environ var
	MS_key_path = r'SOFTWARE\WOW6432Node\Microsoft'
	key_template = MS_key_path + r'\VSWinExpress'

	if _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, key_template, 0, _winreg.KEY_READ):
		key_template = key_template + r'\%s.0'
	else:
		key_template = MS_key_path + r'\VisualStudio\%s.0'

	key = None;	version = 16
	while not key:
		try:
			key_path = key_template % version
			key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, key_path, 0, _winreg.KEY_READ)
		except WindowsError:
			version = version - 1
			if version < 8:
				print "Cannot find Visual Studio 'InstallDir' with template: " + key_template
				exit (1)

	ide_dir = (_winreg.QueryValueEx (key, "InstallDir")[0]).rstrip ('\\')
	while not path.exists (path.join (ide_dir, 'VC')):
		ide_dir = path.dirname (ide_dir)
	result = path.join (ide_dir, 'VC')
	return result

def msvc_compiler_environ (MSC_options, use_vc14_0):
	cpu_options = ['/x86', '/x64']
	target_cpu = MSC_options [0]
	if not target_cpu in cpu_options:
		raise Exception ('Invalid MSC target CPU option' , target_cpu)
		exit (1)

	result = {}
	set_compiler_env_bat = 'set_msvc_compiler_environment.bat'

	# Set setenv.cmd as default environment setting command
	set_env_cmd = microsoft_sdk_path () + 'Bin\\setenv.cmd '
	args = MSC_options

	if use_vc14_0 or not path.exists (set_env_cmd):
		# Set vcvarsall as fall back environment setting command
		set_env_cmd = microsoft_visual_studio_path () + r'\vcvarsall.bat'
		args = [target_cpu [1:]] # trim '\' from \x64
	
	# create script to obtain modified OS environment variables
	f = open (set_compiler_env_bat, 'w')
	f.write ('@echo off\n')
	print 'call "%s" %s\n' % (set_env_cmd, ' '.join (args))
	f.write ('call "%s" %s\n' % (set_env_cmd, ' '.join (args)))
	f.write ('set') # outputs all environment values for parsing
	f.close ()

	# Capture script output
	p = subprocess.Popen([set_compiler_env_bat], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	out, err = p.communicate()
	os.remove (set_compiler_env_bat)
	
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
