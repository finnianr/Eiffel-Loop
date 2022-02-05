note
	description: "Application command line options (copied from Matryoshka app)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 17:16:51 GMT (Saturday 5th February 2022)"
	revision: "5"

class
	APPLICATION_COMMAND_OPTIONS

inherit
	EL_BASE_COMMAND_OPTIONS

create
	make


feature {NONE} -- Constants

	File_placeholder: STRING = "%%f"

end