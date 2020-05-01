import os
from os import path

from eiffel_loop.scons.c_library import LIBRARY_INFO

from eiffel_loop.package import TAR_GZ_SOFTWARE_PACKAGE
from eiffel_loop.package import SOFTWARE_PATCH

info = LIBRARY_INFO ('source/id3.getlib')

print 'is_list', isinstance (info.configure [0], list)

print 'url', info.url

print info.configure

print 'test_data', info.test_data

pkg = TAR_GZ_SOFTWARE_PACKAGE (info.url, info.c_dev, info.extracted)

patch = SOFTWARE_PATCH (info.patch_url, info.c_dev, info.extracted)
patch.apply ()


# create links to `include' and `test_dir'

