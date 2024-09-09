#! /usr/bin/env python

import os

from eiffel_loop.eiffel import project

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE
from eiffel_loop.eiffel.build import FREEZE_BUILD

config = project.read_project_py ()

# False means do not configure MSC
project.set_build_environment (config, False)

ecf = EIFFEL_CONFIG_FILE (config.ecf)

build = FREEZE_BUILD (ecf, config)

build.install_resources ()
