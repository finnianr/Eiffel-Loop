#	description: "Python package selection and download from http://www.lfd.uci.edu/~gohlke/pythonlibs"
#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "25 Dec 2012"
#	revision: "0.1"

# Extract links from package section
# For example:

#	<?xml version="1.0" encoding="utf-8"?>
# 
#	<li><a id="libxml-python"></a><strong><a href="http://xmlsoft.org/python.html">Libxml-python</a></strong> are bindings for the <a href="http://xmlsoft.org/">libxml2</a> and <a href="http://xmlsoft.org/XSLT/">libxslt</a> libraries.
#	<ul>
#	<li><a href='javascript:;' onclick='javascript:dl([109,117,99,119,110,121,113,103,50,105,52,111,97,55,46,120,107,98,56,116,54,47,100,112,108,104,45,101], "2@&lt;=6071EH9A?0H8JG5CI;4J8&gt;=&gt;B&gt;394J&lt;0FD:JG58&gt;D&gt;K?K")' title='[1.4&#160;MB] [Python 2.6] [64 bit] [Dec 30, 2011]'>libxml2-python-2.7.8.win-amd64-py2.6&#46;&#8204;&#101;&#120;&#101;</a></li>
#	<li><a href='javascript:;' onclick='javascript:dl([52,50,100,109,108,111,103,47,113,98,54,99,97,101,55,112,116,45,117,120,121,104,105,46,119,56,110,107], ";K&lt;&gt;836B74F9C341A?D@E5JA1G&gt;GIGHFJA&lt;32:0A?D1G&gt;G=C=")' title='[1.4&#160;MB] [Python 2.7] [64 bit] [Dec 30, 2011]'>libxml2-python-2.7.8.win-amd64-py2.7&#46;&#8204;&#101;&#120;&#101;</a></li>
#	<li><a href='javascript:;' onclick='javascript:dl([56,113,45,50,101,46,98,103,112,108,54,110,107,119,117,97,104,121,105,109,120,55,47,51,99,111,116], "H&lt;?E1C7&gt;F9B6DC9328AJ@I;235E505=B;G328A35:54D4")' title='[1.1&#160;MB] [Python 2.6] [32 bit] [Dec 30, 2011]'>libxml2-python-2.7.8.win32-py2.6&#46;&#8204;&#101;&#120;&#101;</a></li>
#	<li><a href='javascript:;' onclick='javascript:dl([111,110,119,113,108,116,105,99,101,47,45,55,46,121,98,97,107,50,120,104,51,112,56,109,103,117], "7@?;3GHI946&gt;BG4A:E=5C01:A&lt;;&lt;F&lt;261DA:E=A&lt;;&lt;8B8")' title='[1.1&#160;MB] [Python 2.7] [32 bit] [Dec 30, 2011]'>libxml2-python-2.7.8.win32-py2.7&#46;&#8204;&#101;&#120;&#101;</a></li>
#	</ul>

import urllib, platform

from distutils import dir_util
from urllib import FancyURLopener
from string import Template
from os import path
from xml.parsers import expat

def display_progress (a,b,c): 
    # ',' at the end of the line is important!
    print "% 3.1f%% of %d bytes\r" % (min(100, float(a * b) / c * 100), c),

class MOZILLA_OPENER (FancyURLopener):
	# user-agent
	version = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20100101 Firefox/17.0'

class PYTHON_EXTENSION_PACKAGES_FOR_WINDOWS:
	# Package selection and download from http://www.lfd.uci.edu/~gohlke/pythonlibs

	def __init__ (self, package_name):
		self.package_name = package_name
		self._parser = expat.ParserCreate ()
		self._parser.StartElementHandler = self.start
		self.pythonlibs_home = "http://www.lfd.uci.edu/~gohlke/pythonlibs"
		self.packages = []
		xml = self.package_links_XML ()
		print 'Available packages:'
		self.feed (xml)
		self.close()

	def feed (self, data):
		self._parser.Parse (data, 0)

	def close (self):
		self._parser.Parse ("", 1) # end of data
		del self._parser # get rid of circular references

	def start (self, tag, attrs):
		# JavaScript package location obfuscator
		# function dl1 (ml,mi){
		# 	var ot="";
		#	for(var j=0;j<mi.length;j++)ot+=String.fromCharCode(ml[mi.charCodeAt(j)-48]);
		#	location.href=ot;
		# }
		if tag == 'a':
			for name, value in attrs.items ():
				if name == u'onclick':
					pos_left = value.find ('[')
					pos_right = value.find (']')
					exec ('ml =' + value[pos_left:pos_right + 1])

					pos_left = value.find ('"')
					pos_right = value.find ('"', pos_left + 1)
					mi = value[pos_left + 1:pos_right]
					#print '"%s"' % mi

					url_chars = []
					# reverse obfuscation of package name
					for j in range (0, len (mi)):
						url_chars.append (chr (ml [ord (mi[j]) - 48]))

					package = ''.join (url_chars)
					self.packages.append (package)
					print path.basename (package)

	def package_links_XML (self):
		i = 0
		url = self.pythonlibs_home
		print "Reading", url
		#html = urllib.urlopen (url)
		python_libs = MOZILLA_OPENER()
		print 'Connecting ..'
		html = python_libs.open (url)
		result = html.readline ()
		line = ''
		anchor_id = "id='%s'" % self.package_name 
		while (not anchor_id in line):
			print 'Line %s\r' % i,
			line = html.readline ()
			i += 1

		print 'Found ' + self.package_name

		while (not '</ul>' in line):
			print 'Line %s\r' % i,
			line = html.readline ()
			i += 1
			result += line
		print
		html.close ()
		return result

	def dynamic_path_step (self):
		# troublesome first step of path that changes on each page visit
		return (self.packages [0]).split ('/')[0]

	def package_basename (self):
		# returns package appropriate for architecture and Python version
		architecture_names = {'64bit' : 'win-amd64', '32bit' : 'win32'}
		architecture = architecture_names.get (platform.architecture()[0])
		python_version = 'py' + platform.python_version()[0:3]
		result = ''
		for package in self.packages:
			result = path.basename (package)
			if architecture in package and python_version in package:
				break
		
		return result

	def package_url (self):
		return "%s/%s/%s" % (self.pythonlibs_home, self.dynamic_path_step (), self.package_basename ())

	def download (self, download_dir):
		dir_util.mkpath (download_dir)
		python_libs = MOZILLA_OPENER ()
		url = self.package_url ()
		print 'Downloading:', path.basename (url)
		python_libs.retrieve (url, path.join (download_dir, path.basename (url)), display_progress)
		


