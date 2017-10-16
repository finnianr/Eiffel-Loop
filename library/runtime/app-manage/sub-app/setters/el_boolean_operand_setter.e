note
	description: "Sets a `BOOLEAN' operand in `make' routine argument tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-14 11:58:55 GMT (Saturday 14th October 2017)"
	revision: "2"

class
	EL_BOOLEAN_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [BOOLEAN]
		redefine
			set_operand
		end

feature {NONE} -- Implementation

	set_operand (i: INTEGER)
		do
			app.operands.put_boolean (value (Empty_string), i)
		end

	value (str: ZSTRING): BOOLEAN
		do
			Result := Args.word_option_exists (argument.word_option)
		end

end
