note
	description: "Sets a [$source DIR_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "9"

class
	EL_DIR_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [DIR_PATH]
		rename
			english_name as Eng_directory
		end

end