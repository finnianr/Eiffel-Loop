note
	description: "Summary description for {EL_INTEGER_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-01 5:51:18 GMT (Thursday 1st June 2017)"
	revision: "1"

class
	EL_INTEGER_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [INTEGER]
		rename
			put_reference as put_integer
		redefine
			is_convertible, put_integer
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := string_value.is_integer
		end

	put_integer (a_value: like value; i: INTEGER)
		do
			app.operands.put_integer (a_value, i)
		end

	value (str: ZSTRING): INTEGER
		do
			Result := str.to_integer
		end
end
