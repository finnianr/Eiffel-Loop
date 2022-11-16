note
	description: "Application command line options (copied from Matryoshka app)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	APPLICATION_COMMAND_OPTIONS

inherit
	EL_BASE_COMMAND_OPTIONS

create
	make


feature {NONE} -- Constants

	File_placeholder: STRING = "%%f"

end