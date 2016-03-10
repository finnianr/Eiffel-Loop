import os

from eiffel_loop.eiffel import project

from eiffel_loop.eiffel import ecf

from SCons.Environment import Base
from SCons.Variables import Variables
from glob import glob

project_py = project.read_project_py ()
project.set_build_environment (project_py) 

var = Variables ()
var.Add ('cpu', '', 'x64')
var.Add ('project', '', glob ('*.ecf')[0])

os.environ ['ISE_LIBRARY'] = os.environ ['ISE_EIFFEL']

env = Base ()

var.Update (env)

env.Append (ENV = os.environ)
env.Append (ISE_PLATFORM = os.environ ['ISE_PLATFORM'])

config = ecf.FREEZE_BUILD (env, project_py)
config.install_resources (config.resources_destination ())

