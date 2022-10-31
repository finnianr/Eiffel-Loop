note
	description: "Matches if two consective character patterns both have a match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 8:09:51 GMT (Monday 31st October 2022)"
	revision: "2"

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

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		--
		local
			offset: INTEGER
		do
			offset := a_offset
			if text.count > 0 then
				left_operand.match (offset, text)
				if left_operand.is_matched then
					offset := offset + 1
					right_operand.match (offset, text)
					if right_operand.is_matched then
						Result := 2
					end
				end
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- contract support
		local
			left_count, right_count: INTEGER
		do
			if count <= text.count - a_offset then
				left_count := left_operand.match_count (a_offset, text)
				if left_count /= Match_fail then
					right_count := right_operand.match_count (a_offset + left_count, text)
				end
				if right_count /= Match_fail then
					Result := count = left_count + right_count
				end
			end
		end

feature {NONE} -- Internal attributes

	left_operand : EL_SINGLE_CHAR_TEXT_PATTERN

	right_operand: EL_SINGLE_CHAR_TEXT_PATTERN

end
