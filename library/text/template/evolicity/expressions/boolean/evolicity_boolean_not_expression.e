note
	description: "Summary description for {EVOLICITY_BOOLEAN_NOT_EXPRESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EVOLICITY_BOOLEAN_NOT_EXPRESSION

inherit
	EVOLICITY_BOOLEAN_EXPRESSION

create
	make

feature {NONE} -- Initialization

	make (a_operand: EVOLICITY_BOOLEAN_EXPRESSION)
			--
		do
			operand := a_operand
		end

feature -- Basic operation

	evaluate (context: EVOLICITY_CONTEXT)
			--
		do
			operand.evaluate (context)
			if operand.is_true then
				is_true := false
			else
				is_true := true
			end
		end

feature {NONE} -- Implementation

	operand: EVOLICITY_BOOLEAN_EXPRESSION

end