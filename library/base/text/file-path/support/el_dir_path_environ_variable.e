note
	description: "Directory path environment variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_DIR_PATH_ENVIRON_VARIABLE

inherit
	EL_PATH_ENVIRON_VARIABLE [DIR_PATH]

create
	make, make_from_string, default_create

end