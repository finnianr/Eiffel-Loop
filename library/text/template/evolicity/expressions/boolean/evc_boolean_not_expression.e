note
	description: "Evolicity boolean not expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:02:10 GMT (Tuesday 18th March 2025)"
	revision: "6"

class
	EVC_BOOLEAN_NOT_EXPRESSION

inherit
	EVC_BOOLEAN_EXPRESSION

create
	make

feature {NONE} -- Initialization

	make (a_operand: EVC_BOOLEAN_EXPRESSION)
			--
		do
			operand := a_operand
		end

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
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

	operand: EVC_BOOLEAN_EXPRESSION

end