note
	description: "Summary description for {EL_DIR_PATH_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-15 14:54:32 GMT (Tuesday 15th August 2017)"
	revision: "2"

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
