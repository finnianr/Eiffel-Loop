#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "4 June 2010"
#	revision: "0.1"

import subprocess

def win_escape (str):
	result = str [:]
	for c in str:
		if c in "^&()[]{}=;!'+,`~":
			result = result.replace (c, '^' + c)
	return result

def call (args, shell = False, env = None):
	return subprocess.call (args, shell = shell, env = env)

def sudo_call (args, shell = False, env = None):
	# Unix only
	return subprocess.call (['sudo', '-p', 'Enter root password: '] + args, shell = shell, env = env)
