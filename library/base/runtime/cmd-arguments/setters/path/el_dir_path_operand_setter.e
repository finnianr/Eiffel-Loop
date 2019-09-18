note
	description: "Sets a [$source EL_DIR_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-15 9:19:29 GMT (Sunday   15th   September   2019)"
	revision: "7"

class
	EL_DIR_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_DIR_PATH]
		rename
			english_name as Eng_directory
		end

feature {NONE} -- Implementation

	value (str: ZSTRING): EL_DIR_PATH
		do
			Result := str
		end
end
