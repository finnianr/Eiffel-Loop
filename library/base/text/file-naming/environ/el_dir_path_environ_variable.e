note
	description: "Directory path environment variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 14:51:41 GMT (Sunday 15th October 2017)"
	revision: "1"

class
	EL_DIR_PATH_ENVIRON_VARIABLE

inherit
	EL_PATH_ENVIRON_VARIABLE [EL_DIR_PATH]

create
	make, make_from_string, default_create

end
