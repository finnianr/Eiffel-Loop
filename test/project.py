# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

version = (1, 0, 5); build = 270

installation_sub_directory = 'Eiffel-Loop/test'

set_environ ('LD_LIBRARY_PATH', "$EIFFEL_LOOP/C_library/svg-graphics/spec/$ISE_PLATFORM")

tests = TESTS ('$EIFFEL_LOOP/projects.data')
tests.append (['-test', '-logging'])
tests.append (['-test_os_commands', '-logging'])
tests.append (['-test_x2e_and_e2x', '-logging'])
tests.append (['-test_recursive_x2e_and_e2x', '-logging'])
tests.append (['-test_evolicity', '-logging'])
tests.append (['-test_declarative_xpath', '-logging'])

# 1.0.5
# Reimplemented EL_WORK_DISTRIBUTION_THREAD to use semaphores

# 1.0.4
# Changed ZSTRING argument adapation to NOT use appending to once string

# 1.0.2
# Refactored ZSTRING_BENCHMARK_APP

# 1.0.1
# Added ZSTRING_BENCHMARK_APP
