import os

from eiffel_loop.eiffel import ise
from eiffel_loop.eiffel import project

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.ecf import FREEZE_BUILD

from SCons.Environment import Base
from SCons.Variables import Variables
from glob import glob

var = Variables ()
var.Add ('project', '', glob ('*.ecf')[0])

os.environ ['ISE_LIBRARY'] = ise.eiffel

env = Base ()

var.Update (env)

env.Append (ENV = os.environ)
env.Append (ISE_PLATFORM = ise.platform)

project_py = project.read_project_py ()
project_py.set_build_environment ()

ecf_path = env.get ('project')
config = EIFFEL_CONFIG_FILE (ecf_path)

build = FREEZE_BUILD (config, project_py)
build.install_resources (build.resources_destination ())

