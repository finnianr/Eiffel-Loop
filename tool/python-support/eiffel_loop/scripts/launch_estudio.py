#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.2"

import subprocess, sys, os, stat

from distutils import dir_util
from os import path

from eiffel_loop.eiffel import project

config = project.read_project_py ()

if len (sys.argv) == 2:
	project_path = sys.argv [1]
else:
	print "USAGE: launch_estudio <project name>.(pecf|ecf)"
	sys.exit (1)

project.set_build_environment (config, True)

pecf_path = None
parts = path.splitext (project_path)
if parts [1] == '.pecf':
	pecf_path = project_path
	project_path = parts [0] + '.ecf'

	if os.stat (pecf_path)[stat.ST_MTIME] > os.stat (project_path)[stat.ST_MTIME]:
		project.convert_pecf_to_xml (pecf_path)
		
eifgen_path = path.join ('build', config.ise.platform)	
if not path.exists (eifgen_path):
	dir_util.mkpath (eifgen_path)

cmd = ['estudio', '-project_path', eifgen_path, '-config', project_path]
print cmd
ret_code = subprocess.call (cmd)

