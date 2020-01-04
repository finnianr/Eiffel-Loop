note
	description: "Sets a `STRING_8' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "3"

class
	EL_STRING_8_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [STRING_8]

feature {NONE} -- Implementation

	value (str: ZSTRING): STRING_8
		do
			Result := str.to_string_8
		end

end
