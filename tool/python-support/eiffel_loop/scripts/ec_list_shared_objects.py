#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 April 2016"
#	revision: "0.0"

import os, subprocess
from os import path
from optparse import OptionParser

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE

# Install executable from package or F_code directory

usage = "usage: ec_list_shared_objects.py --ecf <ecf-path> [--f_code]"
parser = OptionParser(usage = usage)
parser.add_option (
	"-p", "--platform", action="store", dest = "ise_platform", default = None, help = "ISE platform"
)
parser.add_option (
	"-e", "--ecf", action="store", dest = "ecf_path", default="", help="Eiffel configuration file path"
)
(option, args) = parser.parse_args()

if path.exists (option.ecf_path):
	if option.ise_platform:
		print "Selected platform", option.ise_platform
		ecf = EIFFEL_CONFIG_FILE (option.ecf_path, dict (), option.ise_platform)
	else:
		ecf = EIFFEL_CONFIG_FILE (option.ecf_path)
	
	for objects in ecf.objects_list:
		print objects.description
		for so in objects.shared_libraries ():
			print '  ', so
		print
	
	c_shared_objects = ecf.c_shared_objects
	if c_shared_objects:
		print 'ecf.c_shared_objects:'
		for so in c_shared_objects:
			print ' ', so
	else:
		print "No shared objects"
			
else:
	print "Cannot find", option.ecf_path



