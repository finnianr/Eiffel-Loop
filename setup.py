#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "10 Dec 2012"
#	revision: "0.1"

from distutils.core import setup
from os import path

script_path = path.normpath ('tool/python-support/eiffel_loop/scripts/%s.py')

setup (
	name = 'Eiffel_Loop',
	version = '1.1',
	description = 'Project launch and scons build utilities for EiffelStudio',
	author = 'Finnian Reilly',
	author_email = 'finnian at eiffel hyphen loop dot com',
	url = 'http://www.eiffel-loop.com/python/eiffel_loop/',
	
	packages = [
		'eiffel_loop', 
		'eiffel_loop.eiffel',
		'eiffel_loop.distutils', 
		'eiffel_loop.os', 
		'eiffel_loop.scons', 
		'eiffel_loop.scripts', 
		'eiffel_loop.xml'
	],
	package_dir = {'': 'tool/python-support'},
	scripts = [
		script_path % 'launch_estudio', script_path % 'ec_clean_build', script_path % 'ec_build_finalized'
	]

)
