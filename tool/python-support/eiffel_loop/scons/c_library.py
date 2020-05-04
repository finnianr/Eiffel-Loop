#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 Oct 2019"
#	revision: "0.1"

import os
from os import path

from eiffel_loop.distutils import file_util
from eiffel_loop.package import LIBRARY_INFO
from eiffel_loop.package import TAR_GZ_SOFTWARE_PACKAGE
from eiffel_loop.package import SOFTWARE_PATCH

def build (target, source, env):
	if len (source) > 0 and len (target) > 0:
		dest_path = str (target [0])
		sconscript_path = '/'.join (target [0].get_abspath().split ('/')[0:-3])

		info = LIBRARY_INFO (str (source [0]))
		pkg = TAR_GZ_SOFTWARE_PACKAGE.from_library_info (info)
		patch = None

		if not pkg.unpacked ():
			pkg.download (); pkg.unpack ()
			if info.patch_url:
				patch = SOFTWARE_PATCH (info.patch_url, info.c_dev, info.extracted)
				if not patch.exists ():
					patch.download ()
				patch.apply ()

		for name, actual_name in info.link_table ().items ():
			link_dir_abs = path.join (sconscript_path, name)
			if not path.exists (link_dir_abs):
				print 'Creating link to:', link_dir_abs
				if actual_name == '.':
					os.symlink (pkg.unpacked_dir, link_dir_abs)
				else:
					os.symlink (path.join (pkg.unpacked_dir, actual_name), link_dir_abs)

		src_path = path.join (pkg.unpacked_dir, info.clib)
		if pkg.is_configured ():
			print "Configured '%s' exists" % (info.makefile)
		else:
			pkg.configure (info.configure)

		pkg.build ()

		if path.exists (src_path):
			file_util.copy_file (src_path, dest_path)
			pkg.remove ()
			if patch:
				patch.remove ()
		


