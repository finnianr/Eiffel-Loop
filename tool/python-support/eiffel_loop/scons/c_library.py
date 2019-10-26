#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 Oct 2019"
#	revision: "0.1"

import os
from os import path

from eiffel_loop.distutils import file_util
from eiffel_loop.package import TAR_GZ_SOFTWARE_PACKAGE

class LIBRARY_INFO (object):
	Var_include = 'include'
	Var_test_data = 'test_data'

# Initialization
	def __init__ (self, a_path):
		table = file_util.read_table (a_path)
		if table.has_key (self.Var_include):
			self.include = table [self.Var_include]
		else:
			self.include = None

		if table.has_key (self.Var_test_data):
			self.test_data = table [self.Var_test_data]
		else:
			self.test_data = None

		self.url = table ['url']
		self.c_dev = path.expandvars (table ['c_dev'])
		self.extracted = table ['extracted']
		self.clib = table ['clib']
		self.configure = table ['configure']


def build (target, source, env):
	if len (source) > 0 and len (target) > 0:
		info = LIBRARY_INFO (str (source [0]))
		pkg = TAR_GZ_SOFTWARE_PACKAGE (info.url, info.c_dev, info.extracted)

		if not pkg.unpacked ():
			pkg.download (); pkg.unpack (); pkg.remove ()

		# create links to `include' and `test_dir'
		links = {
			info.Var_include : info.include,
			info.Var_test_data : info.test_data
		}
		for link_dir in links.keys ():
			if links [link_dir]:
				if not path.exists (link_dir):
					os.symlink (path.join (pkg.unpacked_dir, links [link_dir]), link_dir)

		src_path = path.join (pkg.unpacked_dir, info.clib)
		if not path.exists (src_path):
			pkg.build (info.configure)

		dest_path = str (target [0])
		file_util.copy_file (src_path, dest_path)
		


