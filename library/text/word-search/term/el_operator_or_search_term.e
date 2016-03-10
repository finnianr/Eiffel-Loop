note
	description: "Summary description for {OPERATOR_OR_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-16 9:59:47 GMT (Sunday 16th March 2014)"
	revision: "2"

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
