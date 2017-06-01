note
	description: "Summary description for {EL_BOOLEAN_OPERAND_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-31 20:36:00 GMT (Wednesday 31st May 2017)"
	revision: "1"

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
