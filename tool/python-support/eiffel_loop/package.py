#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "13 Dec 2014"
#	revision: "0.1"

from __future__ import absolute_import

import os, zipfile, urllib, platform, xml

from distutils import dir_util
from os import path
from string import Template
from urllib import FancyURLopener

if os.name == 'posix':
	from debian import debfile

from xml.parsers import expat

global download_dir
download_dir = path.normpath (path.expanduser ("~/Downloads/SCons-packages"))

def display_progress (a,b,c): 
    # ',' at the end of the line is important!
    print "% 3.1f%% of %d bytes\r" % (min(100, float(a * b) / c * 100), c),
    #you can also use sys.stdout.write
    #sys.stdout.write("\r% 3.1f%% of %d bytes" 
    #                 % (min(100, float(a * b) / c * 100), c)
    #sys.stdout.flush()

# CLASSES

class SOFTWARE_PACKAGE (object):

# Initialization
	def __init__ (self, url):
		self.url = url
		self.target_table = {}
		
		if url.startswith ("file://"):
			self.file_path = path.normpath (url [7:])
		else:
			self.file_path = path.join (download_dir, url.rsplit ('/')[-1:][0])

			if path.exists (self.file_path):
				print 'Found %s package:' % self.type_name (), self.file_path
			else:
				self.__download ()

# Access
	def type_name (self):
		pass

# Element change
	def append (self, target, member_name):
		if member_name:
			self.target_table [member_name] = target
		else:
			self.target_table [path.basename (target)] = target

# Basic operations
	def extract (self):
		# extract member names as target names
		pass

# Implementation

	def write_member (self, file_content, member_name):
		fpath = self.target_table [member_name]
		print ('Extracting file %s ...' % member_name)
		file_out = open (fpath, 'wb')
		file_out.write (file_content)
		file_out.close ()

	def __download (self):
		dir_util.mkpath (download_dir)
		print 'Downloading:', self.url, ' to:', self.file_path
		urllib.urlretrieve (self.url, self.file_path, display_progress)


class ZIP_SOFTWARE_PACKAGE (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
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

	def extract_all (self, dir_path):
		os.chdir (dir_path)
		zip_file = zipfile.ZipFile (self.file_path, 'r')
		zip_file.extractall ()
		zip_file.close ()
		

class DEBIAN_SOFTWARE_PACKAGE (SOFTWARE_PACKAGE):

# Access
	def type_name (self):
		return 'debian'

# Basic operations
	def extract (self):
		# extract member names as target names
		deb = debfile.DebFile (self.file_path)
		for fpath in deb.data:
			member_name = path.basename (fpath)
			if member_name in self.target_table:
				self.write_member (deb.data.get_content (fpath), member_name)

class LXML_PACKAGE_FOR_WINDOWS:

	def __init__ (self):
		# returns package appropriate for architecture
		names = {'64bit' : 'win-amd64', '32bit' : 'win32'}
		self.package_basename = 'libxml2-python-2.7.8.%s-py2.7.exe' % names.get (platform.architecture()[0])

	def download (self, download_dir):
		result = path.join (download_dir, self.package_basename)
		if path.exists (result):
			print 'Found install', self.package_basename
		else:
			dir_util.mkpath (download_dir)
			url = "http://www.eiffel-loop.com/download/" + self.package_basename
			print 'Downloading:', url
	
			web = FancyURLopener ()
			web.retrieve (url, result, display_progress)

		return result

def display_progress (a, b ,c): 
    # ',' at the end of the line is important!
    print "% 3.1f%% of %d bytes\r" % (min(100, float(a * b) / c * 100), c),


