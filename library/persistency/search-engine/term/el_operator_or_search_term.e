note
	description: "Summary description for {OPERATOR_OR_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "3"

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

	positive_match (target: like WORD_SEARCHABLE): BOOLEAN
			--
		do
			Result := left_operand.matches (target) or else right_operand.matches (target)
		end

	left_operand: EL_SEARCH_TERM

	right_operand: EL_SEARCH_TERM

end
