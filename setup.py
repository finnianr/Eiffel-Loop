#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "17 May 2026"
#	revision: "2.0"

from setuptools import setup

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
	'ec_write_software_version',
	'toggle_display_settings'
]

setup (
	name = 'Eiffel_Loop',
	version = '2.0',
	description = 'Project launch and scons build utilities for EiffelStudio',
	author = 'Finnian Reilly',
	author_email = 'finnian at eiffel hyphen loop dot com',
	url = 'https://www.eiffel-loop.com/python/eiffel_loop/',

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
	package_dir = {'' : 'python-support'},
	entry_points = {
		'console_scripts': [
			'%s = eiffel_loop.scripts.%s:main' % (name, name) for name in script_names
		]
	}
)
		

