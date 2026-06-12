from eiffel_loop.test import *
from eiffel_loop.os import env as os_env

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD

JDK_HOME = 'JDK_HOME'

os.chdir (path.normal ("../test/eiffel2java"))

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)
config.set_export_paths ()

build = FINALIZED_BUILD (config, project_py)

check (JDK_HOME, os.environ [JDK_HOME] == os_env.jdk_home ())

config.print_export_path_dict ('var_names')
var_names = {
	'C_EXPAT' : 'Expat',
	'C_LIB_CURL' : 'cURL',
	'C_NET_ADAPTOR' : 'network-adapter',
	'C_VTD2EIFFEL' : 'vtd2eiffel',
	'C_VTD_XML' : 'VTD-XML-2.7',
	'C_ZLIB' : 'zlib',
	'JDK_HOME' : 'java-21-openjdk-amd64'
}

check_C_library_paths (var_names)
