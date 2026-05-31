#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 May 2026"
#	revision: "0.2"

from .environ import ENVIRONMENT
from .system import FILE_SYSTEM

# create platform specific instances

env = util.os_imp (ENVIRONMENT)
file_system = util.os_imp (FILE_SYSTEM)


