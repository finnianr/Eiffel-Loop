from eiffel_loop.test import *
from eiffel_loop.os import env as os_env

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD

os.chdir (path.normal ("../example/graphical"))

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)
config.set_export_paths ()

build = FINALIZED_BUILD (config, project_py)

# config.print_export_path_dict ('var_names')
var_names = {
	'CAIRO_LIB' : 'Cairo',
	'C_EXPAT' : 'Expat',
	'C_GTK_INIT' :  'gtk-init',
	'C_IMAGE_UTILS' : 'image-utils',
	'C_LIB_CURL' : 'cURL',
	'C_NET_ADAPTOR' : 'network-adapter',
	'C_VTD2EIFFEL' : 'vtd2eiffel',
	'C_VTD_XML' : 'VTD-XML',
	'C_ZLIB' : 'zlib',
	'LIB_CURL' : 'cURL',
	'LIB_VISION2' : 'vision2',
	'VISION2_IMP' : 'implementation'
}
check_C_library_paths (var_names)
