from eiffel_loop.test import *

from eiffel_loop import package

name = package.LIBRARY_NAME ('~/Dev/C/library/cairo-2.7.1b')

check ('name.base', name.base == 'cairo')
check ('name.version', name.version == '2.7.1b')

name = package.LIBRARY_NAME ('~/Dev/C/library/cairo')

check ('name.full', name.base == 'cairo')
check ('name.base', name.base == 'cairo')
check ('no version', not name.has_version ())

