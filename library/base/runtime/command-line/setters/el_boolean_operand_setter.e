note
	description: "Sets a `BOOLEAN' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 15:24:37 GMT (Wednesday 5th October 2022)"
	revision: "5"

class
	EL_BOOLEAN_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [BOOLEAN]
		redefine
			set_operand, value
		end

feature {NONE} -- Implementation

	set_operand (i: INTEGER)
		do
			make_routine.operands.put_boolean (value (Empty_string), i)
		end

	value (str: ZSTRING): BOOLEAN
		do
			Result := Args.word_option_exists (argument.word_option)
		end

end