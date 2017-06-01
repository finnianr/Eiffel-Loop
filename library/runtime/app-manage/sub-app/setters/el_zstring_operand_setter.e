note
	description: "Summary description for {EL_ZSTRING_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-01 7:31:01 GMT (Thursday 1st June 2017)"
	revision: "1"

class
	EL_ZSTRING_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [ZSTRING]

feature {NONE} -- Implementation

	value (str: ZSTRING): ZSTRING
		do
			Result := str
		end

end
