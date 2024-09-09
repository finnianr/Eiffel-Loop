
import os

from eiffel_loop.C_util.C_dev import MICROSOFT_COMPILER_OPTIONS

MSC = MICROSOFT_COMPILER_OPTIONS ()

print MSC.as_switch_string ()

MSC.set_architecture ('x86')

assert (MSC.is_x86_architecture ())

MSC.set_build_type ('Debug')
MSC.set_compatibility ('vista')

print MSC.as_switch_string ()

