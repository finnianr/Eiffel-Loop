#!/usr/bin/python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2019 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "12 Feb 2019"
#	revision: "0.01"

from os import path

from eiffel_loop.eiffel.ecf import EIFFEL_CONFIG_FILE

config = EIFFEL_CONFIG_FILE ("eiffel.ecf")

print config.system.root_class_name ()
print config.system.root_class_path ()
print config.system.cluster_list ()



