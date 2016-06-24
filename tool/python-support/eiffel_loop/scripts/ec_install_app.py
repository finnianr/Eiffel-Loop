#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 April 2016"
#	revision: "0.0"

import os, subprocess
from os import path
from optparse import OptionParser

from eiffel_loop.eiffel.project import EIFFEL_PROJECT

# Install executable from package or F_code directory

usage = "usage: python ec_install_app --install <install directory> [--f_code]"
parser = OptionParser(usage=usage)
parser.add_option (
	"-f", "--f_code", action="store_true", dest="f_code", default=False, help="Install F_code executable"
)
parser.add_option (
	"-i", "--install", action="store", dest="install_dir", default="/usr/local/bin", help="Installation location"
)
(options, args) = parser.parse_args()

project = EIFFEL_PROJECT ()
project.install (options.install_dir, options.f_code)


