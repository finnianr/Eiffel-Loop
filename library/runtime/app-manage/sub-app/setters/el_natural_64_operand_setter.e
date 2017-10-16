note
	description: "Sets a `NATURAL_64' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 8:29:29 GMT (Monday 16th October 2017)"
	revision: "3"

class
	EL_NATURAL_64_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [NATURAL_64]
		rename
			put_reference as put_natural_64
		redefine
			is_convertible, put_natural_64
		end

feature {NONE} -- Implementation

	is_convertible (string_value: ZSTRING): BOOLEAN
		do
			Result := string_value.is_natural_64
		end

	put_natural_64 (a_value: like value; i: INTEGER)
		do
			app.operands.put_natural_64 (a_value, i)
		end

	value (str: ZSTRING): NATURAL_64
		do
			Result := str.to_natural_64
		end
end
