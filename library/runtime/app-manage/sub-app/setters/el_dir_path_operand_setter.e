note
	description: "Sets a [$source EL_DIR_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-14 12:00:07 GMT (Saturday 14th October 2017)"
	revision: "3"

class
	EL_DIR_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_DIR_PATH]

feature {NONE} -- Implementation

	type_name: ZSTRING
		do
			Result := app.Eng_directory
		end

	value (str: ZSTRING): EL_DIR_PATH
		do
			Result := str
		end
end
