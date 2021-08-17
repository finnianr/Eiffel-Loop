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

script_list = [
	script_path % 'launch_estudio',
	script_path % 'ec_build_finalized',
	script_path % 'ec_clean_build',
	script_path % 'ec_gedit_project',
	script_path % 'ec_gedit_implementation',
	script_path % 'ec_install_app',
	script_path % 'ec_install_resources',
	script_path % 'ec_open_directory',
	script_path % 'ec_write_set_environ',
	script_path % 'ec_write_software_version'
]

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
		

