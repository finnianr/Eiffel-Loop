note
	description: "Sets a `BOOLEAN' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-06 12:24:09 GMT (Thursday 6th October 2022)"
	revision: "6"

class
	EL_BOOLEAN_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [BOOLEAN]
		redefine
			try_put_operand, value
		end

feature {NONE} -- Implementation

	try_put_operand
		do
			operands.put_boolean (value (Empty_string), index)
		end

	value (str: ZSTRING): BOOLEAN
		do
			Result := Args.word_option_exists (argument.word_option)
		end

end