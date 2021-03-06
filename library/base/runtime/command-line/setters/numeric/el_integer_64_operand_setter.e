note
	description: "Sets a [$source INTEGER_64] operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-04 10:22:42 GMT (Thursday 4th March 2021)"
	revision: "6"

class
	EL_INTEGER_64_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [INTEGER_64]
		rename
			put_reference as put_integer_64
		redefine
			is_convertible, put_integer_64
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := string_value.is_integer_64
		end

	put_integer_64 (a_value: like value; i: INTEGER)
		do
			make_routine.operands.put_integer_64 (a_value, i)
		end

	value (str: ZSTRING): INTEGER_64
		do
			Result := str.to_integer_64
		end
end