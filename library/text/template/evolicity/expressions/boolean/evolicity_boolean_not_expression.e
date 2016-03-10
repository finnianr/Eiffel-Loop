note
	description: "Summary description for {EVOLICITY_BOOLEAN_NOT_EXPRESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

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
