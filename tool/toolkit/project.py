# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

ecf = 'toolkit.ecf'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test_editors', '-logging'])
