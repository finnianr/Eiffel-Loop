note
	description: "Match left and right char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_MATCH_LEFT_AND_RIGHT_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN
		redefine
			has_action
		end


create
	make

feature {NONE} -- Initialization

	make (a_left_operand, a_right_operand: EL_SINGLE_CHAR_TEXT_PATTERN)
			--
		require
			if_first_negative_then_second_is_not: attached {EL_NEGATED_CHAR_TP} a_left_operand
												implies not attached {EL_NEGATED_CHAR_TP} a_right_operand
			if_not_first_negative_then_second_is: not attached {EL_NEGATED_CHAR_TP} a_left_operand
												implies attached {EL_NEGATED_CHAR_TP} a_right_operand
		do
			make_default
			left_operand := a_left_operand; right_operand := a_right_operand
		end

	name: STRING
		do
			create Result.make (7)
			Result.append (left_operand.name)
			Result.append (" and ")
			Result.append (right_operand.name)
		end

feature -- Status query

	has_action: BOOLEAN
		do
			Result := Precursor or else left_operand.has_action or else right_operand.has_action
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
			--
		do
			if text.count > 0 then
				left_operand.match (text)
				if left_operand.is_matched then
					right_operand.match (text)
					if right_operand.is_matched then
						Result := 2
					end
				end
			end
		end

	left_operand : EL_SINGLE_CHAR_TEXT_PATTERN

	right_operand: EL_SINGLE_CHAR_TEXT_PATTERN

end