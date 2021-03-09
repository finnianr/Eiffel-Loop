# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

set_environ ('ISE_CFLAGS', "-Wno-write-strings")

ecf = "eiffel2java.ecf"

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-java_velocity_test', '-logging'])
tests.append (['-java_test', '-logging'])

