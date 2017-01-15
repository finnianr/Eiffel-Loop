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

def convert_pyxis_to_xml (pecf_path):
	subprocess.call (['el_toolkit', '-pyxis_to_xml', '-no_highlighting', '-in', pecf_path])

project_py = project.read_project_py ()

target_cpu = 'x64'

for arg in sys.argv [1:]:
	if arg.startswith ('cpu='):
		target_cpu = arg.split ('=')[-1]
	else:
		project_path = arg

project_py.set_build_environment (target_cpu)

pecf_path = None
parts = path.splitext (project_path)
if parts [1] == '.pecf':
	pecf_path = project_path
	project_path = parts [0] + '.ecf'

	if os.stat (pecf_path)[stat.ST_MTIME] > os.stat (project_path)[stat.ST_MTIME]:
		convert_pyxis_to_xml (pecf_path)
		
eifgen_path = path.join ('build', os.environ ['ISE_PLATFORM'])	
if not path.exists (eifgen_path):
	dir_util.mkpath (eifgen_path)

#s = raw_input ("Return")
#print project.ascii_environ

print 'PATH', os.environ ['PATH']
cmd = ['estudio', '-project_path', eifgen_path, '-config', project_path]
print cmd
ret_code = subprocess.call (cmd)

