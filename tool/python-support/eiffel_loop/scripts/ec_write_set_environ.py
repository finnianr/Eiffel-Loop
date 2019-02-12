#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "26 Oct 2016"
#	revision: "0.2"

import platform, subprocess, sys, os, stat

from distutils import dir_util
from os import path
from optparse import OptionParser

from eiffel_loop.eiffel import project


# Word around for bug "LookupError: unknown encoding: cp65001"
if platform.system () == "Windows":
	platform_name = "windows"
	codecs.register (lambda name: codecs.lookup ('utf-8') if name == 'cp65001' else None)
else:
	platform_name = "unix"

usage = "usage: ec_write_set_environ [--x86]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-x", "--x86", action="store_true", dest="x86", default=False, help="Write set_environ.sh for 32 bit compilation"
)
(options, args) = parser.parse_args()

project_py = project.read_project_py ()

if options.x86:
	project_py.set_build_environment ('x86')
else:
	project_py.set_build_environment ('x64')

sh = 'set_environ.sh'
print "Writing", sh

f = open (sh, 'w')
env = project_py.eiffel_environ ()
for key in sorted (env):
	f.write ("export %s=%s\n" % (key, env [key]))
f.close ()


	

