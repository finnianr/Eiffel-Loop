note
	description: "Sets a `DOUBLE' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "4"

class
	EL_DOUBLE_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [DOUBLE]
		rename
			put_reference as put_real_64
		redefine
			is_convertible, put_real_64
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := string_value.is_real_64
		end

	put_real_64 (a_value: like value; i: INTEGER)
		do
			app.operands.put_real_64 (a_value, i)
		end

	value (str: ZSTRING): DOUBLE
		do
			Result := str.to_real_64
		end
end
