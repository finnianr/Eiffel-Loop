# EiffelStudio project environment

from eiffel_loop.project import *

environ ['LD_LIBRARY_PATH'] = "$EIFFEL_LOOP/C_library/svg-graphics/spec/$ISE_PLATFORM"

version = (1, 0, 3)

installation_sub_directory = 'Eiffel-Loop/test'

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test', '-logging'])
tests.append (['-test_os_commands', '-logging'])
tests.append (['-test_x2e_and_e2x', '-logging'])
tests.append (['-test_recursive_x2e_and_e2x', '-logging'])
tests.append (['-test_evolicity', '-logging'])
tests.append (['-test_declarative_xpath', '-logging'])

# 1.0.2
# Refactored ZSTRING_BENCHMARK_APP

# 1.0.1
# Added ZSTRING_BENCHMARK_APP
