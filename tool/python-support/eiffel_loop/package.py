#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "13 Dec 2014"
#	revision: "0.1"

from __future__ import absolute_import

import os, subprocess, tarfile, zipfile, urllib, platform, xml
from eiffel_loop.distutils import file_util

from distutils import dir_util
from os import path
from string import Template
from urllib import FancyURLopener

if os.name == 'posix':
	from debian import debfile

from xml.parsers import expat

global default_download_dir
default_download_dir = path.normpath (path.expanduser ("~/Downloads/SCons-packages"))

def display_progress (a, b, c): 
    # ',' at the end of the line is important!
    print "% 3.1f%% of %d bytes\r" % (min(100, float(a * b) / c * 100), c),
    #you can also use sys.stdout.write
    #sys.stdout.write("\r% 3.1f%% of %d bytes" 
    #                 % (min(100, float(a * b) / c * 100), c)
    #sys.stdout.flush()

# CLASSES

class LIBRARY_INFO (object):
# information from .getlib source file	

# Initialization
	def __init__ (self, a_path):
		self.test_data = None
		self.include = None
		self.url = None
		self.clib = None
		self.extracted = None
		self.configure = None
		self.makefile = 'Makefile'
		self.patch_url = None
		
		for k, v in file_util.read_table (a_path).items():
			setattr (self, k, v)

		if self.c_dev:
			self.c_dev = path.expandvars (self.c_dev)

# Access
	def link_table (self):
		# links to `include' and `test_dir'
		result = {}
		if self.include:
			result ['include'] = self.include
		if self.test_data:
			result ['test_data'] = self.test_data

		return result


class SOFTWARE_PACKAGE (object):

# Initialization
	def __init__ (self, url, dest_dir = default_download_dir, rel_unpacked = None, makefile = 'Makefile'):
		self.url = url
		self.target_table = {}
		self.dest_dir = dest_dir # download directory
		self.makefile = makefile

		self.basename = url.rsplit ('/')[-1:][0]
		if rel_unpacked:
			self.unpacked_dir = path.join (dest_dir, rel_unpacked)
		else:
			ext_count = len (self.extension ()) + 1
			self.unpacked_dir = path.join (dest_dir, self.basename [: -ext_count])

		if url.startswith ("file://"):
			self.file_path = path.normpath (url [7:])
		else:
			self.file_path = path.join (dest_dir, self.basename)
	
	@classmethod
	def from_library_info (cls, info):
		return cls (info.url, info.c_dev, info.extracted, info.makefile)

# Access
	def type_name (self):
		pass

	def extension (self):
		pass

	def name (self):
		return path.basename (self.url)

# Status query
	def exists (self):
		return path.exists (self.file_path)

	def unpacked (self):
		return path.exists (self.unpacked_dir)

	def is_configured (self):
		return path.exists (path.join (self.unpacked_dir, self.makefile))
	

# Element change
	def append (self, target, member_name):
		if member_name:
			self.target_table [member_name] = target
		else:
			self.target_table [path.basename (target)] = target

# Basic operations
	def download (self):
		if not self.exists ():
			dir_util.mkpath (self.dest_dir)
			print 'Downloading:', self.basename, ' to:', self.dest_dir
			urllib.urlretrieve (self.url, self.file_path, display_progress)
		
	def extract (self):
		# extract member names as target names
		pass

	def pushd (self):
		self.cwd = os.getcwd()

	def popd (self):
		os.chdir (self.cwd)

	def chdir_package (self, extracted_dir = None):
		self.pushd ()
		if extracted_dir:
			os.chdir (path.join (self.dest_dir, extracted_dir))
		else:
			os.chdir (self.dest_dir)

	def remove (self):
		# remove archive `self.file_path'
		if path.exists (self.file_path):
			os.remove (self.file_path)

# Implementation

	def write_member (self, file_content, member_name):
		fpath = self.target_table [member_name]
		print ('Extracting file %s ...' % member_name)
		file_out = open (fpath, 'wb')
		file_out.write (file_content)
		file_out.close ()

class ZIP_SOFTWARE_PACKAGE (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
		return 'zip archive'

	def extension (self):
		return 'zip'

# Basic operations
	def extract (self):
		# extract member names as target names
		print "Reading zip file:", self.file_path
		zip_file = zipfile.ZipFile (self.file_path, 'r')
		for fpath in zip_file.namelist ():
			member_name = path.basename (fpath)
			if member_name in self.target_table:
				self.write_member (zip_file.read (fpath), member_name)
		zip_file.close ()

	def unpack (self):
		self.chdir_package ()
		zip_file = zipfile.ZipFile (self.file_path, 'r')
		zip_file.extractall ()
		zip_file.close ()
		self.popd ()
		

class DEBIAN_SOFTWARE_PACKAGE (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
		return 'Debian package'

	def extension (self):
		return 'deb'

# Basic operations
	def extract (self):
		# extract member names as target names
		deb = debfile.DebFile (self.file_path)
		for fpath in deb.data:
			member_name = path.basename (fpath)
			if member_name in self.target_table:
				self.write_member (deb.data.get_content (fpath), member_name)

class TAR_GZ_SOFTWARE_PACKAGE (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
		return 'Compressed TAR archive'

	def extension (self):
		return 'tar.gz'

# Basic operations
	def unpack (self):
		self.chdir_package ()
		# extract member names as target names
		tar = tarfile.open(self.file_path, "r:gz")
		tar.extractall()
		tar.close ()
		self.popd ()

	def configure (self, configure_cmd):
		# configure package with `configure_cmd' command or lists of commands
		self.chdir_package (self.unpacked_dir)
		if isinstance (configure_cmd, list):
			cmd_list = configure_cmd
		else:
			cmd_list = [configure_cmd]

		for cmd in cmd_list:
			if not subprocess.call (cmd.split (' ')) == 0:
				raise Exception ("Configuration command failed: " + cmd)			
		self.popd ()

	def build (self):
		# build package using `extracted_dir' relative
		if self.is_configured ():
			self.chdir_package (self.unpacked_dir)
			subprocess.call (['make'])
			self.popd ()
		else:
			raise Exception ("Not configured. No %s found" % (self.makefile))

class WINDOWS_INSTALL_PACKAGE (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
		return 'Windows Installer'

	def extension (self):
		return 'exe'

# Basic operations
	def install (self):
		return subprocess.call ([self.file_path])
	

class SOFTWARE_PATCH (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
		return 'Code Patch'

	def extension (self):
		return 'patch'

# Basic operations
	def apply (self):
		self.chdir_package (self.unpacked_dir)
		cmd = ['patch', '-Np1', '-i', self.file_path]
		subprocess.call (cmd)
		self.popd ()
	

