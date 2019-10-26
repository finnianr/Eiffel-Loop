import os
from os import path

from eiffel_loop.scons.c_library import LIBRARY_INFO

from eiffel_loop.package import TAR_GZ_SOFTWARE_PACKAGE

info = LIBRARY_INFO ('source/taglib.getlib')

pkg = TAR_GZ_SOFTWARE_PACKAGE (info.url, info.c_dev, info.extracted)

# create links to `include' and `test_dir'
links = {
	info.Var_include : info.include,
	info.Var_test_data : info.test_data
}
for link_dir in links.keys ():
	if links [link_dir]:
		print link_dir, ':', links [link_dir]
		if not path.exists (link_dir):
			print path.join (pkg.unpacked_dir, links [link_dir])
			os.symlink (path.join (pkg.unpacked_dir, links [link_dir]), link_dir)

