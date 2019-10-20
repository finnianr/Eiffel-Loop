#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 Oct 2019"
#	revision: "0.1"

import os
from os import path
from eiffel_loop.distutils import file_util
from glob import glob
# from string import Template

# from eiffel_loop.package import ZIP_SOFTWARE_PACKAGE

def build (target, source, env):
	if len (source) > 0 and len (target) > 0:
		table = file_util.read_table (str (source [0]))
		extracted_dir = path.expandvars (table ['extracted'])
		clib = table ['clib']
		url = table ['url']
		include = table ['include']

		include_link = 'include'
		if not path.exists (include_link):
			os.symlink (path.join (extracted_dir, include), include_link)

		src_path = path.join (extracted_dir, clib)
		dest_path = str (target [0])
		file_util.copy_file (src_path, dest_path)
		


