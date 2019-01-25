note
	description: "Sets a [$source EL_FILE_PATH] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 1:51:05 GMT (Friday 25th January 2019)"
	revision: "6"

class
	EL_FILE_PATH_OPERAND_SETTER

inherit
	EL_PATH_OPERAND_SETTER [EL_FILE_PATH]

feature {NONE} -- Implementation

	value (str: ZSTRING): EL_FILE_PATH
		do
			Result := str
		end

end
