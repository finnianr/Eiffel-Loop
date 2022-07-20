#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "10 Dec 2012"
#	revision: "0.1"
import os, sys
from distutils.core import setup
from os import path


#setup (
#	name = 'ghar',
#	version = '2020-7',
#	description = 'Windows support for symlinks',
#	author = 'Onno Broekmans',
#	author_email = 'onnodb@gmail.com',
#	url = 'https://github.com/philips/ghar',
#	
#	packages = ['ghar'],
#	package_dir = {'' : 'contrib/Python'}
#)

Launch_bat_script = """
@echo off
set script_name=%~dp0Scripts\%~n0.py
python "%script_name%" %*
"""

python_home_dir = os.path.dirname (os.path.realpath (sys.executable))

script_path = path.normpath ('tool/python-support/eiffel_loop/scripts/%s.py')

script_names = [
	'launch_estudio',
	'build_c_library',
	'ec_autotest_build',
	'ec_build_finalized',
	'ec_clean_build',
	'ec_gedit_project',
	'ec_gedit_implementation',
	'ec_list_shared_objects',
	'ec_install_app',
	'ec_install_resources',
	'ec_open_directory',
	'ec_write_set_environ',
	'ec_write_software_version'
]
script_list = [script_path % name for name in script_names]

print script_list

setup (
	name = 'Eiffel_Loop',
	version = '1.1',
	description = 'Project launch and scons build utilities for EiffelStudio',
	author = 'Finnian Reilly',
	author_email = 'finnian at eiffel hyphen loop dot com',
	url = 'http://www.eiffel-loop.com/python/eiffel_loop/',
	
	packages = [
		'eiffel_loop', 
		'eiffel_loop.C_util',
		'eiffel_loop.eiffel',
		'eiffel_loop.distutils', 
		'eiffel_loop.os', 
		'eiffel_loop.scons', 
		'eiffel_loop.scripts', 
		'eiffel_loop.xml'
	],
	package_dir = {'' : 'tool/python-support'},
	scripts = script_list
)
if sys.platform == 'win32':
	for script_name in script_list:
		bat_path = path.join (python_home_dir, path.basename (script_name))
		bat_path = path.splitext (bat_path)[0] + '.bat'
		print "Writing script:", bat_path
		f = open (bat_path, 'w')
		f.write (Launch_bat_script)
		f.close ()
		

