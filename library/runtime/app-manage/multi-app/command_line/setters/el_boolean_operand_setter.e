note
	description: "Sets a `BOOLEAN' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-18 13:08:31 GMT (Monday 18th November 2024)"
	revision: "9"

class
	EL_BOOLEAN_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [BOOLEAN]
		redefine
			try_put_operand, value
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	try_put_operand
		do
			operands.put_boolean (value (Empty_string), index)
		end

	value (str: ZSTRING): BOOLEAN
		do
			if argument.has_value then
				Result := argument.string_value.to_boolean
			else
				Result := argument.exists
			end
		end

end