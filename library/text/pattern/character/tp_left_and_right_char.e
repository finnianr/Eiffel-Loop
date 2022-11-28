note
	description: "Matches if two consective character patterns both have a match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 5:08:27 GMT (Monday 28th November 2022)"
	revision: "4"

class
	TP_LEFT_AND_RIGHT_CHAR

inherit
	TP_CHARACTER_PATTERN
		redefine
			action_count
		end


create
	make

feature {NONE} -- Initialization

	make (a_left_operand, a_right_operand: TP_CHARACTER_PATTERN)
			--
		require
			if_first_negative_then_second_is_not: attached {TP_NEGATED_CHAR} a_left_operand
												implies not attached {TP_NEGATED_CHAR} a_right_operand
			if_not_first_negative_then_second_is: not attached {TP_NEGATED_CHAR} a_left_operand
												implies attached {TP_NEGATED_CHAR} a_right_operand
		do
			left_operand := a_left_operand; right_operand := a_right_operand
		end

feature -- Status query

	action_count: INTEGER
		do
			Result := Precursor + left_operand.action_count + right_operand.action_count
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
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			left_count, right_count: INTEGER
		do
			left_count := left_operand.match_count (a_offset, text)
			if left_count /= Match_fail then
				right_count := right_operand.match_count (a_offset + left_count, text)
			end
			if right_count /= Match_fail then
				Result := count = left_count + right_count
			end
		end

	name_inserts: TUPLE
		do
			Result := [left_operand.name, right_operand.name]
		end

feature {NONE} -- Internal attributes

	left_operand : TP_CHARACTER_PATTERN

	right_operand: TP_CHARACTER_PATTERN

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S and %S"
		end
end
