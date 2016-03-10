#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "11 Jan 2010"
#	revision: "0.1"

import os, platform
from os import path

def curdir ():
	result = path.abspath (os.curdir)
	return result

def curdir_up_to (step):
	result = curdir ()
	if step in result.split (os.sep):
		while path.basename (result) != step:
			result = path.dirname (result)
	return result
