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

MSC_options = project_py.MSC_options
cpu_option = 'x64'

if not '/x64' in MSC_options:
	MSC_options.append ('/x64')

for arg in sys.argv [1:]:
	if arg.startswith ('cpu='):
		cpu_option = arg.split ('=')[-1]
		if cpu_option in ['x86', 'x64']:
			MSC_options.append ('/' + cpu_option)
		else:
			raise Exception('Invalid argument', arg)
	else:
		project_path = arg

project_py.update_os_environ (cpu_option == 'x86')

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

