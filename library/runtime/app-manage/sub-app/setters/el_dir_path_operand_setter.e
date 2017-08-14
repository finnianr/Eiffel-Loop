note
	description: "Summary description for {EL_DIR_PATH_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-01 5:29:03 GMT (Thursday 1st June 2017)"
	revision: "1"

class
	EL_DIR_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_DIR_PATH]

feature {NONE} -- Implementation

	type_name: ZSTRING
		do
			Result := app.English_directory
		end

	value (str: ZSTRING): EL_DIR_PATH
		do
			Result := str
		end
end
