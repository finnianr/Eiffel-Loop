#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.2"

import subprocess, sys, os

from eiffel_loop.distutils import dir_util
from eiffel_loop.os import path

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE

def main():

	if len (sys.argv) == 2:
		ecf_path = path.as_ecf (sys.argv [1])
		
		project_py = project.read_project_py (ecf_path)

		project.set_build_environment (project_py)
		project_py.print_environ ()
		project.update_ecf (ecf_path)

		config = EIFFEL_CONFIG_FILE (project_py.ecf)
		config.set_export_paths ()

		build_path = path.join ('build', project_py.ise.platform)
		if not path.exists (build_path):
			dir_util.mkpath (build_path)

		# /w: wait until launched process exits (not sure about this)
		cmd = ['estudio', '-project_path', build_path, '-config', ecf_path]
		print(cmd)
		subprocess.call (cmd)

	else:
		print ("USAGE: launch_estudio <project name>.(pecf|ecf)")
		print ("NOTE: -project_path is always 'build/$ISE_PLATFORM'")


if __name__ == '__main__':
	main()

