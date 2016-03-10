#! /usr/bin/env python

import os, sys, platform

from os import path
from distutils import dir_util
from subprocess import call

project_ecf = sys.argv [1]

if project_ecf:
	# Build for each architecture
	if platform.system () == "Windows":
		build_cmd = ['python', path.join (os.path.dirname (os.path.realpath (sys.executable)), 'scons.py')]
	else:
		build_cmd = ['scons']

	eifgen_steps = ['build', os.environ ['ISE_PLATFORM'], 'EIFGENs']
	eifgen_path = os.sep.join (eifgen_steps)
	if path.exists (eifgen_path):
		dir_util.remove_tree (eifgen_path)

	call (build_cmd + ['action=freeze', 'project=' + project_ecf])
else:
	print "No project file specified"

s = raw_input ('<return> to exit')

