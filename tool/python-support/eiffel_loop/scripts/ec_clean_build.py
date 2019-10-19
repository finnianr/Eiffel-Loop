#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 April 2016"
#	revision: "0.0"

import os, sys, platform

from os import path
from distutils import dir_util
from subprocess import call
from eiffel_loop.eiffel import ise

project_ecf = sys.argv [1]

if project_ecf:
	# Build for each architecture
	if platform.system () == "Windows":
		build_cmd = ['python', path.join (os.path.dirname (os.path.realpath (sys.executable)), 'scons.py')]
		platform_name	= 'windows'
	else:
		platform_name	= 'unix'
		build_cmd = ['scons']

	eifgen_steps = ['build', ise.platform, 'EIFGENs']
	eifgen_path = os.sep.join (eifgen_steps)
	if path.exists (eifgen_path):
		dir_util.remove_tree (eifgen_path)

	f_code_tar = path.join ('build', 'F_code-%s.tar') % platform_name
	if path.exists (f_code_tar):
		os.remove (f_code_tar)

	call (build_cmd + ['action=freeze', 'project=' + project_ecf])
else:
	print "No project file specified"

s = raw_input ('<return> to exit')

