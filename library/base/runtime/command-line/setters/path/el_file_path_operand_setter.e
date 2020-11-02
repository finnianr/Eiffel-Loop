note
	description: "Sets a [$source EL_FILE_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-30 9:30:21 GMT (Friday 30th October 2020)"
	revision: "8"

class
	EL_FILE_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_FILE_PATH]
		rename
			english_name as Eng_file
		end
end