#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 April 2016"
#	revision: "0.0"

import os, sys, platform, codecs

from os import path
from subprocess import call
from optparse import OptionParser
from glob import glob

from eiffel_loop.eiffel.project import EIFFEL_PROJECT
from eiffel_loop.eiffel.project import increment_build_number

# Word around for bug "LookupError: unknown encoding: cp65001"
if platform.system () == "Windows":
	codecs.register (lambda name: codecs.lookup ('utf-8') if name == 'cp65001' else None)

usage = "usage: python create_installer [--x86]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-x", "--x86", action="store_true", dest="build_x86", default=False, help="Build a 32 bit version in addition to 64 bit"
)
parser.add_option (
	"-i", "--install", action="store", dest="install_dir", default=None, help="Installation location"
)
(options, args) = parser.parse_args()

target_architectures = ['x64']

if options.build_x86:
	target_architectures.append ('x86')
	
# Find project ECF file
ecf_name = glob ("*.ecf")[0]
project_name = path.splitext (ecf_name)[0]

# Update project.py build_number for `build_info.e'
increment_build_number ()

# Build for each architecture
if platform.system () == "Windows":
	build_cmd = ['python', path.join (os.path.dirname (os.path.realpath (sys.executable)), 'scons.py')]
else:
	build_cmd = ['scons']

for cpu_target in target_architectures:
	call (build_cmd + ['cpu=' + cpu_target, 'action=finalize', 'project=%s.ecf' % project_name])

(options, args) = parser.parse_args()

# Install with version link
if options.install_dir:
	project = EIFFEL_PROJECT ()
	project.install (options.install_dir)

