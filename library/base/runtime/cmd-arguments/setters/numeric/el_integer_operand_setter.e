note
	description: "Sets a `INTEGER' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:35:23 GMT (Friday 25th January 2019)"
	revision: "4"

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
			make_routine.operands.put_integer (a_value, i)
		end

	value (str: ZSTRING): INTEGER
		do
			Result := str.to_integer
		end
end
