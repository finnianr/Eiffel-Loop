note
	description: "Sets a [$source STRING_32] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:52:47 GMT (Tuesday 2nd March 2021)"
	revision: "4"

class
	EL_STRING_32_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [STRING_32]

feature {NONE} -- Implementation

	value (str: ZSTRING): STRING_32
		do
			Result := str.to_string_32
		end

end