#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 Dec 2012"
#	revision: "0.1"

# Using easy_install with .egg packages can solve the problem of unattended setup script

# Download from https://pypi.org/project/setuptools/5.4.2/
# Install setuptools-5.4.2.zip to give easy_install.exe

# http://apt-mirror.front.sepia.ceph.com/pypi/packages/2.7/l/lxml/
# Use easy_install to install lxml-2.3-py2.7-amd64.egg

import os, sys, subprocess, platform, zipfile

from distutils import dir_util, file_util
from os import path

from eiffel_loop.os import environ
from eiffel_loop.os.environ import REGISTRY_NODE
from eiffel_loop import package
from eiffel_loop.package import ZIP_SOFTWARE_PACKAGE
from eiffel_loop.package import WINDOWS_INSTALL_PACKAGE
from eiffel_loop.eiffel import project
from eiffel_loop.scripts import templates

from eiffel_loop.eiffel import ise_environ
if sys.platform == "win32":
	import _winreg

ise = ise_environ.shared

python_home_dir = environ.python_home_dir()
eiffel_loop_home_dir = path.abspath (os.curdir)

def el_download_url (package_basename):
	result = "http://www.eiffel-loop.com/download/" + package_basename
	return result

def libxml2_url ():
	names = {'64bit' : 'win-amd64', '32bit' : 'win32'}
	basename = 'libxml2-python-2.7.8.%s-py2.7.exe' % names.get (platform.architecture()[0])
	result = el_download_url (basename)
	return result

def gedit_home_dir ():
	software_dir = 'SOFTWARE'
	result = None

	# Check for gedit 3.2 (win64)
	gedit_path = path.join (software_dir, r'GNOME\gedit Text Editor (64 bit)')	
	try:
		gedit_reg = REGISTRY_NODE (_winreg.HKEY_CURRENT_USER, gedit_path)
		result = gedit_reg.value ("InstallPath")

	except (WindowsError), err:
		pass
	
	if not result:
		# Check for gedit 2.3 (win32)
		if platform.architecture ()[0] == '64bit':
			gedit_path = path.join (software_dir, 'Wow6432Node')
		else:
			gedit_path = software_dir
		gedit_path = path.join (gedit_path, r'Microsoft\Windows\CurrentVersion\Uninstall\gedit_is1')

		try:
			gedit_reg = REGISTRY_NODE (_winreg.HKEY_LOCAL_MACHINE, gedit_path)
			result = gedit_reg.value ("InstallLocation")

		except (WindowsError), err:
			pass

	return result

class INSTALLER (object): # Common: Unix and Windows
	def build_eiffel_tool (self):
		
		os.chdir (path.join (eiffel_loop_home_dir, path.normpath ('tool/eiffel')))
		if not environ.command_exists (['el_eiffel', '-version', '-no_highlighting'], shell=self.is_windows ()):
			bin_path = self.tools_bin ()
			if not path.exists (bin_path):
				dir_util.mkpath (bin_path)
			# for windows compatiblity
			build_cmd = ['python', '-m', 'eiffel_loop.scripts.ec_build_finalized.py', '--install', bin_path]
			if subprocess.call (build_cmd, shell=self.is_windows ()) == 0:
				self.print_completion ()
			else:
				print 'ERROR: failed to build required tool: el_eiffel'

	def write_script_file (self, a_path, content):
		print 'Writing:', a_path
		f = open (a_path, 'w')
		f.write (content)
		f.close ()

	def tools_bin (self):
		pass

	def is_windows (self):
		pass

	def print_completion (self):
		pass

	def install_precompiles (self, ise_platform):
		el_precomp = path.join (ise.precomp, "EL")
		precomp = 'precomp'
		dir_util.mkpath (el_precomp)
		for ecf in os.listdir (precomp):
			if path.splitext (ecf)[1] == '.ecf':
				print 'Copying', path.join (precomp, ecf), '->', el_precomp
				file_util.copy_file (path.join (precomp, ecf), el_precomp)

class WINDOWS_INSTALLER (INSTALLER):

	def __init__ (self):
		pass

	def install (self):
		self.install_scons ()
		
		self.install_lxml ()

		self.install_batch_scripts ()
	
		self.install_precompiles (ise.platform)
		self.build_eiffel_tool ()
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
		if not environ.command_exists (['scons', '-v'], shell = True):
			scons_package = ZIP_SOFTWARE_PACKAGE (el_download_url ('scons-2.2.0.zip'))
			if not scons_package.unpacked ():
				scons_package.download ()
				scons_package.unpack ()

			os.chdir (scons_package.unpacked_dir)

			install_scons_cmd = ['python', 'setup.py', 'install', '--standard-lib']
			print install_scons_cmd
			if subprocess.call (install_scons_cmd) == 0:
				file_util.copy_file (path.join (python_home_dir, r'Scripts\scons.py'), python_home_dir)
				os.chdir (scons_package.dest_dir) # change to parent to prevent a permission problem when removing
				dir_util.remove_tree (scons_package.unpacked_dir)
			else:
				print 'ERROR: scons installation failed'

	def install_lxml (self):
		try:
			import lxml
		except (ImportError), e:
			# Install python-lxml for xpath support
			pkg_lxml = WINDOWS_INSTALL_PACKAGE (libxml2_url ())
			print "Follow the instructions to install required Python package: lxml"
			s = raw_input ('Press <return> to download and install')
			pkg_lxml.download ()
			if pkg_lxml.install () != 0:
				print "Error installing Python package: lxml"

	def install_batch_scripts (self):
		# Write scripts into Python home
		self.write_script_file (path.join (python_home_dir, 'launch_estudio.bat'), templates.launch_estudio_bat)

	def install_gedit_pecf_support (self):
		# If gedit installed, install pecf syntax
		os.chdir (path.join (eiffel_loop_home_dir, r'tool\eiffel'))

		edit_cmd = None
	
		gedit_dir = gedit_home_dir ()
		if gedit_dir:
			print gedit_dir
			local_app_data = path.join (path.dirname (path.expandvars ('$APPDATA')), 'Local')
			gtksourceview_dir = path.join (local_app_data, 'gtksourceview-%s.0') % self.__gtk_version (gedit_dir) 
			specs_dir = path.join (gtksourceview_dir, 'language-specs')
			dir_util.mkpath (specs_dir)
			print "Installing Pyxis ECF syntax highlighting support:"
			print " ", specs_dir
			for name in os.listdir ('language-specs'):
				file_path = path.join ('language-specs', name)
				if path.exists (file_path):
					print "  source:", file_path
					file_util.copy_file (file_path, specs_dir)

			gedit_exe_path = path.join (gedit_dir, r'bin\gedit.exe')
			if path.exists (gedit_exe_path):
				edit_cmd = '"%s"  "%%1"' % gedit_exe_path
		else:
			print 'It is recommended to install the gedit Text editor for editing .pecf files.'
			print 'Download and install from https://wiki.gnome.org/Apps/Gedit.'
			print "Then run 'setup.bat' again."
			r = raw_input ("Press <return> to continue")

		py_icon_path = path.join (python_home_dir, 'DLLs', 'py.ico')
		estudio_logo_path = r'"%ISE_EIFFEL%\contrib\examples\web\ewf\upload_image\htdocs\favicon.ico"'

		conversion_cmd = 'cmd /C el_eiffel -pecf_to_xml -ask_user_to_quit -in "%1"'
		open_with_estudio_cmd = '"%s" "%%1"' % path.join (python_home_dir, "launch_estudio.bat")

		ecf_extension_cmds = {'open' : open_with_estudio_cmd }
		pecf_extension_cmds = {'open' : open_with_estudio_cmd, 'Convert To ECF' : conversion_cmd }
		pyx_extension_cmds = {'Convert To XML' : conversion_cmd }
		if edit_cmd:
			pecf_extension_cmds ['edit'] = edit_cmd
			pyx_extension_cmds ['open'] = edit_cmd
			pyx_extension_cmds ['edit'] = edit_cmd

		classes_root = REGISTRY_NODE (_winreg.HKEY_CLASSES_ROOT)

		mime_types = [
			('.ecf', 'XML.ECF.File', 'Eiffel XML Configuration File', estudio_logo_path, ecf_extension_cmds),
			('.pecf', 'Pyxis.ECF.File', 'Eiffel Pyxis Configuration File', estudio_logo_path, pecf_extension_cmds),
			('.pyx', 'Pyxis.File', 'Pyxis Data File', py_icon_path, pyx_extension_cmds)
		]
		for extension_name, pyxis_key_name, description, icon_path, extension_cmds in mime_types:
			classes_root.key_path = extension_name
			classes_root.set_value (pyxis_key_name)

			pyxis_shell_path = path.join (pyxis_key_name, 'shell')
			for command_name, command in extension_cmds.iteritems():
				command_path = path.join (pyxis_shell_path, command_name, 'command')
				print 'Setting:', command_path, 'to', command
				classes_root.key_path = command_path			
				classes_root.set_value (command)

			classes_root.key_path = pyxis_key_name			
			classes_root.set_value (description)

			classes_root.key_path = path.join (pyxis_key_name, 'DefaultIcon')			
			classes_root.set_expandable_value (icon_path)

	def install_precompiles (self, ise_platform):
		super (WINDOWS_INSTALLER, self).install_precompiles (ise_platform)
		if ise_platform == ise.Platform_64_bit:
			if path.exists (project.x86_path (ise.eiffel)):
				super (WINDOWS_INSTALLER, self).install_precompiles ('windows')

# Implementation
	def __gtk_version (self, gedit_dir):
		result = 3
		for gtk_ver in range (2, 4):
			specs_dir = path.join (gedit_dir, r'share\gtksourceview-%s.0\language-specs' % gtk_ver)
			if path.exists (specs_dir):
				result = gtk_ver
				break
		return result

class UNIX_INSTALLER (INSTALLER):

	def __init__ (self):
		pass

	def install (self):
		user_bin_dir = path.expanduser ('~/bin')
		dir_util.mkpath (user_bin_dir)
		launch_estudio_path = path.join (user_bin_dir, 'launch_estudio')
		self.write_script_file (launch_estudio_path, templates.launch_estudio)
		os.chmod (launch_estudio_path, 0777)

		self.install_precompiles (ise.platform)

		self.build_eiffel_tool ()

		self.install_gedit_pecf_support ()

	def is_windows (self):
		return False

	def tools_bin (self):
		return path.expanduser ('/usr/local/bin')

	def install_gedit_pecf_support (self):
		os.chdir (path.join (eiffel_loop_home_dir, 'tool/eiffel'))

		# Install language specs for both gedit 2.3 and gedit 3.2
		language_specs_dir = 'language-specs'
		user_share_dir = path.expanduser ('~/.local/share')
		for version in range (2, 4): # 2 to 3
			gtksourceview_dir = path.join (user_share_dir, 'gtksourceview-%s.0' % version, language_specs_dir)
			if path.exists (gtksourceview_dir):
				for copied_path in dir_util.copy_tree (language_specs_dir, gtksourceview_dir):
					print copied_path

		mime_packages_dir = 'mime/packages'
		for copied_path in dir_util.copy_tree (mime_packages_dir, path.join (user_share_dir, mime_packages_dir)):
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
		
	#installer.install ()
	installer.install_gedit_pecf_support ()


