
import os

from eiffel_loop.eiffel import project
from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FINALIZED_BUILD

from eiffel_loop.eiffel import ise_environ
ise = ise_environ.shared

def check (name, test_result):
	assert test_result, "Unexpected result for: " + name

os.chdir ("../eiffel")

project_py = project.read_project_py ()

project.set_build_environment (project_py)
project_py.print_environ ()

config = EIFFEL_CONFIG_FILE (project_py.ecf)

build = FINALIZED_BUILD (config, project_py)

check ("build_type", build.build_type () == 'F_code')

check ("resources_destination", build.resources_destination () == "build/%s/package" % ise.platform)

check ("code_dir", build.code_dir () == "build/%s/EIFGENs/classic/F_code" % ise.platform)

check ("f_code_tar_unix_path", build.f_code_tar_unix_path () == "build/F_code-%s.tar" % config.platform)

check ("4 parts", build.system.version ().long_string ('.').count ('.') == 3) 



