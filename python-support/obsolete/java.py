#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "18 May 2009"
#	revision: "0.1"

# OBSOLETE MODULE

import os, sys

from os import path
from subprocess import call

def print_status (prompt,  call_ret_code):
	if call_ret_code == 0:
		print prompt, 'OK'
	else:
		print prompt, 'ERROR'

# Compile directory of Java classes
def compile (input_dir, output_dir):
	os.chdir (input_dir)
	if not path.exists (output_dir):
		os.mkdir (output_dir)
	ret_code = call ('javac -d %s *.java' % (output_dir), shell=True)
	print_status ('Java compilation:', ret_code)
