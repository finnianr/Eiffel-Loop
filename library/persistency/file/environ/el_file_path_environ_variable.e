note
	description: "File path environment variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 9:34:34 GMT (Monday 5th December 2022)"
	revision: "5"

class
	EL_FILE_PATH_ENVIRON_VARIABLE

inherit
	EL_PATH_ENVIRON_VARIABLE [FILE_PATH]

create
	make, make_from_string, default_create

end