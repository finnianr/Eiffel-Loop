#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "12 Feb 2019"
#	revision: "0.01"

# Description: Generates the script `set_environ.sh' which can be used to setup Eiffel compilation environment

import platform, subprocess, sys, os, stat

from distutils import dir_util
from os import path
from optparse import OptionParser

from eiffel_loop.eiffel import project


# Word around for bug "LookupError: unknown encoding: cp65001"
if platform.system () == "Windows":
	codecs.register (lambda name: codecs.lookup ('utf-8') if name == 'cp65001' else None)

usage = "usage: ec_write_set_environ [--x86]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-x", "--x86", action="store_true", dest="x86", default = False, help="Write set_environ.sh for 32 bit compilation"
)
(options, args) = parser.parse_args()

config = project.read_project_py ()

if options.x86:
	config.MSC_options [0] = 'x86'
	
project.set_build_environment (config)

sh = 'set_environ.sh'
print "Writing", sh

f = open (sh, 'w')
env = config.eiffel_environ ()
for key in sorted (env):
	line = "export %s=%s\n" % (key, env [key])
	print line
	f.write (line)
f.close ()


	

