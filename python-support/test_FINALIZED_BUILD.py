
import os

from eiffel_loop.os import path
from eiffel_loop.test import check
from eiffel_loop.os import env as os_env

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD

os.chdir (path.normal ("../test"))

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)

config.set_export_paths ()

build = FINALIZED_BUILD (config, project_py)

config.print_export_path_dict ('var_names')
var_names = {
	'CAIRO_LIB' : 'Cairo-1.12.16',
	'C_EXPAT' : 'Expat',
	'C_GTK_INIT' : 'gtk-init',
	'C_IMAGE_UTILS' : 'image-utils',
	'C_LIB_CURL' : 'cURL',
	'C_NET_ADAPTOR' : 'network-adapter',
	'C_VTD2EIFFEL' : 'vtd2eiffel',
	'C_VTD_XML' : 'VTD-XML-2.7',
	'C_ZLIB' : 'zlib',
	'LIB_VISION2' : 'vision2',
	'VISION2_IMP' : 'implementation'
}

for key, value in var_names.items ():
	dir_path = os.environ [key]
	succeeds = path.exists (dir_path) and path.basename (dir_path).startswith (value)
	check (key + " exists and matches", succeeds)
