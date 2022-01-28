#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.2"

import subprocess, sys, os

from distutils import dir_util
from eiffel_loop.os import path

from eiffel_loop.eiffel import project

config = project.read_project_py ()

if len (sys.argv) == 2:
	ecf_path = path.as_ecf (sys.argv [1])
else:
	print "USAGE: launch_estudio <project name>.(pecf|ecf)"
	sys.exit (1)

project.set_build_environment (config)
config.print_environ ()

project.update_ecf (ecf_path)
		
eifgen_path = path.join ('build', config.ise.platform)	
if not path.exists (eifgen_path):
	dir_util.mkpath (eifgen_path)

cmd = ['estudio', '-ecf_path', eifgen_path, '-config', ecf_path]
print cmd
ret_code = subprocess.call (cmd)

