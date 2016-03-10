#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "16 Dec 2011"
#	revision: "0.1"

#	Description: Creates a default build environment for EiffelStudio projects

import platform, sys

from eiffel_loop.os import path
from eiffel_loop.os import environ
from eiffel_loop.eiffel.test import TESTS

environ = { 

	'EIFFEL_LOOP'					: path.curdir_up_to ('Eiffel-Loop'),

	'EIFFEL_LOOP_C' 				: '$EIFFEL_LOOP/C_library',

	# Java
	'JDK_HOME' 						: environ.jdk_home (),

	# Third party C/C++ libraries

	'PYTHON_HOME'   				: environ.python_home_dir (),
	'PYTHON_LIB_NAME'	  			: environ.python_dir_name (),

	'EXPAT' 						: '$EIFFEL_LOOP/contrib/C/Expat',
	'VTD_XML_INCLUDE' 				: '$EIFFEL_LOOP/contrib/C/VTD-XML.2.7/include'
}

MSC_options = ['/x64', '/xp', '/Release']

if not sys.platform == 'win32':
	environ ['LANG'] = 'C'

