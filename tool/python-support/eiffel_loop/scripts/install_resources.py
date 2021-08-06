import os

from eiffel_loop.eiffel import ise
from eiffel_loop.eiffel import project

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.ecf import FREEZE_BUILD

from SCons.Environment import Base
from SCons.Variables import Variables

var = Variables (); env = Base ()

var.Update (env)

project_py = project.read_project_py ()
project_py.set_build_environment ()

env.Append (ENV = os.environ, ISE_PLATFORM = ise.platform, ISE_C_COMPILER = ise.c_compiler)

config = EIFFEL_CONFIG_FILE (project_py.ecf)

build = FREEZE_BUILD (config, project_py)
build.install_resources ()

