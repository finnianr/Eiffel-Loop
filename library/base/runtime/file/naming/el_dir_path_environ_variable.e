note
	description: "Directory path environment variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-27 9:47:04 GMT (Sunday 27th November 2022)"
	revision: "4"

class
	EL_DIR_PATH_ENVIRON_VARIABLE

inherit
	EL_PATH_ENVIRON_VARIABLE [DIR_PATH]

create
	make, make_from_string, default_create

end