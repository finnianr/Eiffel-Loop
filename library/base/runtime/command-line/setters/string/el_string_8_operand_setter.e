note
	description: "Sets a [$source STRING_8] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:56:08 GMT (Tuesday 2nd March 2021)"
	revision: "4"

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