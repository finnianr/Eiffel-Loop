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

from eiffel_loop.eiffel.project import EIFFEL_PROJECT

# Install executable from package or F_code directory

usage = "usage: python ec_write_software_version.py --file <output-file>"
parser = OptionParser(usage=usage)
parser.add_option (
	"-f", "--file", action="store", dest="file_path", default='version.txt', help="Output file for software version to file"
)
(options, args) = parser.parse_args()

project = EIFFEL_PROJECT () 
print "%s version: %s" % (project.exe_name, project.version)

f = open (options.file_path, 'w')
f.write (project.version)
f.close ()



