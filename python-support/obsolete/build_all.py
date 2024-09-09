#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "18 May 2009"
#	revision: "0.1"

# OBSOLETE MODULE

import os, string, re, sys

from os import path
from glob import glob
from subprocess import call

el_home = path.abspath (os.curdir)

# Build C libraries
import c_lang
c_library_path = path.join (el_home, 'C_library')
os.chdir (c_library_path)

for file_path in glob (path.normpath ('*/source/Makefile')):
	c_lang.make_library (path.join (c_library_path, file_path))

# Build Java classes
import java
for dir_path, dir_names, file_names in os.walk (el_home):
	if 'java_source' in dir_names:
		java.compile (path.join (dir_path, 'java_source'), path.join (dir_path, 'java_classes'))

import eiffel
precomp_dir = path.join (el_home, 'precomp')
os.chdir (precomp_dir)

# Do Eiffel precompilations
for ecf in glob ('*.ecf'):
	eiffel.precompile_project (precomp_dir, ecf)

# Setup os environment
eiffel.set_eiffel_loop_environment (el_home, c_library_path)

#Build all Eiffel projects except for ones in precomp and laabhair
for dir_path, dir_names, file_names in os.walk (el_home):
	for file_name in file_names:
		if re.match (r"^.*\.ecf$", file_name):
			if not path.basename (dir_path) in ['precomp', 'laabhair']:
				eiffel.freeze_project (dir_path, file_name)
				eiffel.write_environment_to_sh_script ()



