from eiffel_loop.test import *

from eiffel_loop.C_util import C_dev as C

defs = "EIF_THREADS EIF_LINUXTHREADS ISE_GC" 

check ('define_list', ['-c'] + C.define_list (defs) == ['-c', '-DEIF_THREADS', '-DEIF_LINUXTHREADS', '-DISE_GC'])

