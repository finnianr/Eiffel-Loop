#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 Dec 2012"
#	revision: "0.1"

import os, sys, subprocess, platform, zipfile

from distutils import dir_util, file_util
from os import path

from eiffel_loop.os import environ
from eiffel_loop import package
from eiffel_loop.package import ZIP_SOFTWARE_PACKAGE
from eiffel_loop.package import PYTHON_EXTENSION_PACKAGES_FOR_WINDOWS

if sys.platform == "win32":
	import _winreg

from eiffel_loop.scripts import templates

python_home_dir = environ.python_home_dir()
eiffel_loop_home_dir = path.abspath (os.curdir)
	
class INSTALLER: # Common: Unix and Windows
	def build_toolkit (self):
		
		os.chdir (path.join (eiffel_loop_home_dir, path.normpath ('tool/toolkit')))
		if not environ.command_exists (['el_toolkit', '-pyxis_to_xml', '-h'], shell=self.is_windows ()):
			if subprocess.call (['scons', 'project=toolkit.ecf', 'action=finalize'], shell=self.is_windows ()) == 0:
				dir_util.mkpath (self.tools_bin ())
				package_bin = path.expandvars (path.normpath ('package/$ISE_PLATFORM/bin'))
				for dest_path in dir_util.copy_tree (package_bin, self.tools_bin ()):
					print 'Copied:', dest_path
				self.print_completion ()
			else:
				print 'ERROR: failed to build el_toolkit'

	def write_script_file (self, a_path, content):
		print 'Writing:', a_path
		f = open (a_path, 'w')
		f.write (content)
		f.close

	def tools_bin (self):
		pass

	def is_windows (self):
		pass

	def print_completion (self):
		pass

class WINDOWS_INSTALLER (INSTALLER):

	def __init__ (self):
		pass

	def install (self):
		self.install_scons ()
		
		self.install_lxml ()

		self.install_batch_scripts ()
	
		self.build_toolkit ()
		self.install_gedit_pecf_support ()

	def tools_bin (self):
		return path.expandvars (r'$ProgramFiles\Eiffel-Loop\bin')

	def is_windows (self):
		return True

	def print_completion (self):
		print 
		print 'To use the Pyxis conversion tool, please add "%s"' % self.tools_bin ()
		print 'to your \'Path\' environment variable.'

	def install_scons (self):
		os.chdir (eiffel_loop_home_dir)
		if not environ.command_exists (['scons', '-v'], shell = True):
			scons_package = ZIP_SOFTWARE_PACKAGE ('http://freefr.dl.sourceforge.net/project/scons/scons/2.2.0/scons-2.2.0.zip')
			scons_package.extract_all (package.download_dir)

			scons_name = path.basename (scons_package.url)

			os.chdir (path.splitext (scons_name)[0])
			install_scons_cmd = ['python', 'setup.py', 'install', '--standard-lib']
			print install_scons_cmd
			if subprocess.call (install_scons_cmd) == 0:
				file_util.copy_file (path.join (python_home_dir, r'Scripts\scons.py'), python_home_dir)
				dir_util.remove_tree (scons_name [0])
			else:
				print 'ERROR: scons installation failed'

	def install_lxml (self):
		# Install python-lxml for xpath support
		os.chdir (eiffel_loop_home_dir)
		try:
			import lxml
		except (ImportError), e:
			py_packages = PYTHON_EXTENSION_PACKAGES_FOR_WINDOWS ('lxml')
			py_packages.download ('Downloads')
			print "Follow the instructions to install required Python package: lxml"
			s = raw_input ('Press <return> to continue')
			if subprocess.call ([path.join ('Downloads', py_packages.package_basename ())]) != 0:
				print "Error installing Python package: lxml"

	def install_batch_scripts (self):
		# Write scripts into Python home
		key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, r'SOFTWARE\Microsoft\Microsoft SDKs\Windows', 0, _winreg.KEY_READ)
		sdk_path = _winreg.QueryValueEx (key, "CurrentInstallFolder")[0]
		setenv_cmd_path = path.join (path.normpath (sdk_path), 'Bin\\setenv.cmd')
		print setenv_cmd_path

		batch_file_templates = [
			('launch_estudio.bat', templates.launch_estudio_bat),
			('set_msc_environment.bat', templates.set_msc_environment_txt)
		]
		for batch_name, template in batch_file_templates:
			self.write_script_file (
				path.join (python_home_dir, batch_name), 
				template.substitute (setenv_cmd_path = setenv_cmd_path, python_home_dir = python_home_dir)
			)

	def install_gedit_pecf_support (self):
		# If gedit installed, install pecf syntax
		os.chdir (path.join (eiffel_loop_home_dir, r'tool\toolkit'))
	
		gedit_path = 'SOFTWARE'
		gedit_exe_path = None
		if platform.architecture ()[0] == '64bit':
			gedit_path = path.join (gedit_path, 'Wow6432Node')
		try:
			gedit_path = path.join (gedit_path, r'Microsoft\Windows\CurrentVersion\Uninstall\gedit_is1')
			key = _winreg.OpenKey (_winreg.HKEY_LOCAL_MACHINE, gedit_path, 0, _winreg.KEY_READ)
			gedit_home = _winreg.QueryValueEx (key, "InstallLocation")[0]
			gedit_exe_path = path.join (gedit_home, r'bin\gedit.exe')

			dir_util.copy_tree ('language-specs', path.join (gedit_home, r'share\gtksourceview-2.0\language-specs'))

		except (WindowsError), err:
				print 'gedit not installed'
	
		if gedit_exe_path:
			py_icon_path = path.join (python_home_dir, 'DLLs', 'py.ico')
			estudio_logo_path = r'"%ISE_EIFFEL%\contrib\examples\web\ewf\upload_image\htdocs\favicon.ico"'

			conversion_cmd = 'cmd /C el_toolkit -pyxis_to_xml -remain -in "%1"'
			edit_cmd = '"%s"  "%%1"' % gedit_exe_path
			open_with_estudio_cmd = '"%s" "%%1"' % path.join (python_home_dir, "launch_estudio.bat")
			open_with_gedit_cmd = edit_cmd

			pecf_extension_cmds = { 'edit' : edit_cmd, 'open' : open_with_estudio_cmd, 'Convert To ECF' : conversion_cmd }
			pyx_extension_cmds = { 'edit' : edit_cmd, 'open' : open_with_gedit_cmd, 'Convert To XML' : conversion_cmd }

			mime_types = [
				('.pecf', 'Pyxis.ECF.File', 'Pyxis Eiffel Configuration File', estudio_logo_path, pecf_extension_cmds),
				('.pyx', 'Pyxis.File', 'Pyxis Data File', py_icon_path, pyx_extension_cmds)
			]
			for extension_name, pyxis_key_name, description, icon_path, extension_cmds in mime_types:
				key = _winreg.CreateKeyEx (_winreg.HKEY_CLASSES_ROOT, extension_name, 0, _winreg.KEY_ALL_ACCESS)
				_winreg.SetValue (key, '', _winreg.REG_SZ, pyxis_key_name)

				pyxis_shell_path = path.join (pyxis_key_name, 'shell')
				for command_name, command in extension_cmds.iteritems():
					command_path = path.join (pyxis_shell_path, command_name, 'command')
					print 'Setting:', command_path, 'to', command
					key = _winreg.CreateKeyEx (_winreg.HKEY_CLASSES_ROOT, command_path, 0, _winreg.KEY_ALL_ACCESS)
					_winreg.SetValue (key, '', _winreg.REG_SZ, command)

				key = _winreg.CreateKeyEx (_winreg.HKEY_CLASSES_ROOT, pyxis_key_name, 0, _winreg.KEY_ALL_ACCESS)
				_winreg.SetValue (key, '', _winreg.REG_SZ, description)

				key = _winreg.CreateKeyEx (_winreg.HKEY_CLASSES_ROOT, path.join (pyxis_key_name, 'DefaultIcon'), 0, _winreg.KEY_ALL_ACCESS)
				_winreg.SetValue (key, '', _winreg.REG_SZ, icon_path)


class UNIX_INSTALLER (INSTALLER):

	def __init__ (self):
		pass

	def install (self):
		user_bin_dir = path.expanduser ('~/bin')
		dir_util.mkpath (user_bin_dir)
		launch_estudio_path = path.join (user_bin_dir, 'launch_estudio')
		self.write_script_file (launch_estudio_path, templates.launch_estudio)
		os.chmod (launch_estudio_path, 0777)

		self.build_toolkit ()

		self.install_gedit_pecf_support ()

	def is_windows (self):
		return False

	def tools_bin (self):
		return path.expanduser ('~/bin')

	def install_gedit_pecf_support (self):
		os.chdir (path.join (eiffel_loop_home_dir, 'tool/toolkit'))

		user_share_dir = path.expanduser ('~/.local/share')
		for lang_dir, steps in [('mime/packages', 2), ('gtksourceview-2.0/language-specs', 1)]:
			if steps == 1:
				source = path.split (lang_dir)[1]
			else:
				source = lang_dir
			for copied_path in dir_util.copy_tree (source, path.join (user_share_dir, lang_dir)):
				print copied_path

		update_cmd = ['update-mime-database', path.join (user_share_dir, 'mime')]
		print 'Calling:', update_cmd,
		if int (subprocess.call (update_cmd)) == 0:
			print 'OK'
		else:
			print 'FAILED'

if platform.python_version_tuple () >= ('3','0','0'):
	print 'ERROR: Python Version %s is not suitable for use with scons build system' % platform.python_version ()
	print 'Please use a version prior to 3.0.0 (Python 2.7 recommended)'
	print 'Setup not completed'
else:
	if sys.platform == "win32":
		installer = WINDOWS_INSTALLER ()
	else:
		installer = UNIX_INSTALLER ()
		
	installer.install ()

