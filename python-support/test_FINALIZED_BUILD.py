
import os

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD

from eiffel_loop.eiffel import ise_environ
ise = ise_environ.shared

def check (name, test_result):
	print 'Checking', name,
	assert test_result, "Unexpected result for: " + name
	print 'OK'

def normpath (path, insert = None):
	result = os.path.normpath (path)
	if insert:
		result = result % insert
	return result

os.chdir (normpath ("../tool/eiffel"))

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)

build = FINALIZED_BUILD (config, project_py)

check ("compatibility_mode", build.compatibility_mode == 'Win7')

check ("build_type", build.build_type () == 'F_code')

check ("resources_destination", build.resources_destination () == normpath ("build/%s/package", ise.platform))

check ("code_dir", build.code_dir () == normpath ("build/%s/EIFGENs/classic/F_code", ise.platform))

check ("f_code_tar_unix_path", build.f_code_tar_unix_path () == "build/F_code-%s.tar" % config.platform)

check ("4_parts", build.system.version ().long_string ('.').count ('.') == 3) 



