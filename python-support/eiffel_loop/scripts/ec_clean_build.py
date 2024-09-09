#! /usr/bin/env python

#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "9 April 2016"
#	revision: "0.0"

from eiffel_loop.eiffel import project as ecf_project

project = ecf_project.new_eiffel_project ()

project.clean_build ()

s = raw_input ('<return> to exit')

