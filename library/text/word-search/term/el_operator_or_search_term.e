note
	description: "Summary description for {OPERATOR_OR_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_OPERATOR_OR_SEARCH_TERM

inherit
	EL_SEARCH_TERM

create
	make

feature {NONE} -- Initialization

	make (a_left_operand, a_right_operand: like left_operand)
			--
		do
			left_operand := a_left_operand
			right_operand := a_right_operand
		end

feature {NONE} -- Implementation

	matches (target: like Type_target): BOOLEAN
			--
		do
			Result := left_operand.meets_criteria (target) or else right_operand.meets_criteria (target)
		end

	left_operand: EL_SEARCH_TERM

	right_operand: EL_SEARCH_TERM

end
