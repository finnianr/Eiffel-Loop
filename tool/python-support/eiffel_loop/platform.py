#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "19 Oct 2019"
#	revision: "0.1"

from __future__ import absolute_import

import os

def is_unix ():
	return (os.name == 'posix')

def is_windows ():
	return (os.name == 'nt')

def opposing (value):
	result = 'unix' if value == 'windows' else 'windows'

	return result

def name ():
	result = 'unix' if is_unix () else 'windows'
	return result

