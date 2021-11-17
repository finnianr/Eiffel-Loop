import os

from eiffel_loop.eiffel import project
from eiffel_loop.os import environ

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.ecf import FREEZE_BUILD

environ.print_path ()

from SCons.Environment import Base
from SCons.Variables import Variables

var = Variables (); env = Base ()

var.Update (env)

config = project.read_project_py ()
project.set_build_environment (config)

ise = config.ise

env.Append (ENV = os.environ, ISE_PLATFORM = ise.platform, ISE_C_COMPILER = ise.c_compiler)

build = FREEZE_BUILD (EIFFEL_CONFIG_FILE (config.ecf), config)
build.install_resources ()

