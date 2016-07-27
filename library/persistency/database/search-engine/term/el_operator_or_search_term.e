note
	description: "Summary description for {OPERATOR_OR_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-13 10:17:23 GMT (Wednesday 13th January 2016)"
	revision: "4"

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

	positive_match (target: like Type_target): BOOLEAN
			--
		do
			Result := left_operand.matches (target) or else right_operand.matches (target)
		end

	left_operand: EL_SEARCH_TERM

	right_operand: EL_SEARCH_TERM

end