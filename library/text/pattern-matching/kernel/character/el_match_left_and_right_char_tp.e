note
	description: "Summary description for {EL_MATCH_LEFT_AND_RIGHT_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATCH_LEFT_AND_RIGHT_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXTUAL_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_left_operand, a_right_operand: EL_SINGLE_CHAR_TEXTUAL_PATTERN)
			--
		require
			if_first_negative_then_second_is_not: attached {EL_NEGATED_CHAR_TP} a_left_operand
												implies not attached {EL_NEGATED_CHAR_TP} a_right_operand
			if_not_first_negative_then_second_is: not attached {EL_NEGATED_CHAR_TP} a_left_operand
												implies attached {EL_NEGATED_CHAR_TP} a_right_operand
		do
			default_create
			left_operand := a_left_operand
			right_operand := a_right_operand
		end

feature {NONE} -- Implementation

	actual_try_to_match
			--
		do
			if target_text.count > 0 then
				left_operand.set_target (target_text)
				left_operand.try_to_match
				if left_operand.match_succeeded then
					right_operand.set_target (target_text)
					right_operand.try_to_match
					if right_operand.match_succeeded then
						match_succeeded := True
						count_characters_matched := 1
					end
				end
			end
		end

	left_operand : EL_SINGLE_CHAR_TEXTUAL_PATTERN

	right_operand: EL_SINGLE_CHAR_TEXTUAL_PATTERN

end
