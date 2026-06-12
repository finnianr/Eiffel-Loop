
from pathlib import Path

from eiffel_loop.test import *
from eiffel_loop.os import env as os_env

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD


os.chdir (path.normal ("../test/ID3-tags"))

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)

config.set_export_paths ()

build = FINALIZED_BUILD (config, project_py)

config.print_export_path_dict ('var_names')

var_names = {
	'C_EXPAT' : 'Expat',
	'C_LIB_CURL' : 'cURL',
	'C_NET_ADAPTOR' : 'network-adapter',
	'C_VTD2EIFFEL' : 'vtd2eiffel',
	'C_VTD_XML' : 'VTD-XML-2.7',
	'C_ZLIB' : 'zlib',
	'EL_CPP_ID3LIB' : 'id3lib',
	'EL_C_ID3TAG' : 'libid3tag',
	'EXT_CPP_ID3LIB' : 'id3lib-3.8.3',
	'EXT_C_ID3TAG' : 'libid3tag-0.15.1b'

}
check_C_library_paths (var_names)

check ('OS_SPEC', Path (os.environ ['OS_SPEC']).name ==  os.environ ['ISE_PLATFORM'])


