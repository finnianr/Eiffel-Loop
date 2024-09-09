#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "13 Dec 2014"
#	revision: "0.1"

import os
from os import path
from string import Template

from eiffel_loop.package import ZIP_SOFTWARE_PACKAGE
from eiffel_loop.package import DEBIAN_SOFTWARE_PACKAGE
from eiffel_loop.package import TAR_GZ_SOFTWARE_PACKAGE
from eiffel_loop.eiffel import ise_environ

global ise
ise = ise_environ.shared

if os.name == 'posix':
	from debian import debfile

def get (target, source, env):
	subst_variables = platform_variables ()
	
	# Scons builder action to extract targets from sources
	packages = {}
	for i in range (0, len (source)):
		print 'source [%s]' % i, source [i]
		url, member_name = source_url_and_member_name (str (source [i]), subst_variables)
		if url in packages:
			package = packages [url]
		else:
			extension = path.splitext (url)[1]
			if extension == ".zip":
				package = ZIP_SOFTWARE_PACKAGE (url)
			elif extension == ".gz":
				package = TAR_GZ_SOFTWARE_PACKAGE (url)
			elif extension == ".deb":
				package = DEBIAN_SOFTWARE_PACKAGE (url)
			else:
				print 'ERROR invalid extension "%s"' % extension
			packages [url] = package
		
		package.append (str (target [i]), member_name)

	package.download ()
	for package in packages.values():
		package.extract ()

def source_url_and_member_name (get_fpath, variables):
	i = 1; member_name = None
	f = open (get_fpath, 'r')
	for line in f.readlines ():
		expanded_line = Template (line.rstrip ()).substitute (variables)
		if i == 1:
			source_url = expanded_line
		elif expanded_line.startswith ('get '):
			member_name = expanded_line [4:]
			member_name = member_name.strip ()
			break
		i = i + 1
	
	f.close ()
	return (source_url, member_name)

def platform_variables ():
	result = {}
	
	var_gnome_platform = 'GNOME_PLATFORM'
	var_debian_platform = 'DEB_PLATFORM'
	var_cpu_bits = 'CPU_BITS'
	
	if ise.platform == 'windows':
		cpu_bits = '32'; gnome_platform = 'win32'; debian_platform = 'i386'

	elif ise.platform == 'win64':
		cpu_bits = '64'; gnome_platform = 'win64'; debian_platform = 'amd64'

	elif ise.platform.endswith ('x86-64'):
		cpu_bits = '64'; gnome_platform = ''; debian_platform = 'amd64'
	else:
		cpu_bits = '32'; gnome_platform = ''; debian_platform = 'i386'
	
	result [var_cpu_bits] = cpu_bits
	result [var_gnome_platform] = gnome_platform
	result [var_debian_platform] = debian_platform

	return result


