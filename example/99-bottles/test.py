import os, sys

from eiffel_loop.eiffel.project import new_eiffel_project

project = new_eiffel_project ()

project.increment_build_number ()
