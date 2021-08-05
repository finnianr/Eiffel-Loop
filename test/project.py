# EiffelStudio project environment

from eiffel_loop.eiffel.dev_environ import *

ecf = 'test.ecf'
build_info_path = "source/root/build_info.e"

set_environ ('LD_LIBRARY_PATH', "$EIFFEL_LOOP/C_library/image-utils/spec/$ISE_PLATFORM")

#keep_assertions = True
