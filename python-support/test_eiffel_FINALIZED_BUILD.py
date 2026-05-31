from eiffel_loop.test import *

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD

from eiffel_loop.eiffel import ise_environ
ise = ise_environ.shared

os.chdir (path.normal ("../tool/eiffel"))

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)
config.set_export_paths ()

build = FINALIZED_BUILD (config, project_py)

check ("root_class_name", config.system.root_class_name () == 'APPLICATION_ROOT')
check ("system.type", config.system.type () == 'classic')

check ("msc_compatibility", build.msc_compatibility == 'win7')

check ("build_type", build.build_type () == 'F_code')

check ("resources_destination", build.resources_destination () == path.normal ("build/%s/package", ise.platform))

check ("code_dir", build.code_dir () == path.normal ("build/%s/EIFGENs/classic/F_code", ise.platform))

check ("f_code_tar_unix_path", build.f_code_tar_unix_path () == "build/F_code-%s.tar" % config.platform)

check ("4_parts", build.system.version ().long_string ('.').count ('.') == 3) 

# config.print_export_path_dict ('var_names')
var_names = {
	'C_EXPAT' : 'Expat',
	'C_LIB_CURL' : 'cURL',
	'C_NET_ADAPTOR' : 'network-adapter',
	'C_VTD2EIFFEL' : 'vtd2eiffel',
	'C_VTD_XML' : 'VTD-XML-2.7',
	'C_ZLIB' : 'zlib',
	'LIB_CURL' : 'cURL'
}
check_C_library_paths (var_names)



