#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 Oct 2019"
#	revision: "0.1"

import os
from os import path
from string import Template

from eiffel_loop.package import ZIP_SOFTWARE_PACKAGE

def get (target, source, env):
	subst_variables = platform_variables ()
	

