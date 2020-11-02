note
	description: "Sets a [$source EL_DIR_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-30 9:29:30 GMT (Friday 30th October 2020)"
	revision: "8"

class
	EL_DIR_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_DIR_PATH]
		rename
			english_name as Eng_directory
		end

end