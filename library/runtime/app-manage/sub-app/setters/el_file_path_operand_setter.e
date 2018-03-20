note
	description: "Sets a [$source EL_FILE_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:22:20 GMT (Wednesday 21st February 2018)"
	revision: "4"

class
	EL_FILE_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_FILE_PATH]

feature {NONE} -- Implementation

	type_name: ZSTRING
		do
			Result := app.Eng_file
		end

	value (str: ZSTRING): EL_FILE_PATH
		do
			Result := str
		end

end
