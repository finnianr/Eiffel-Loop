note
	description: "Matches character in ASCII range"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:08:17 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_MATCH_CHAR_IN_ASCII_RANGE_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_lower, a_upper: CHARACTER)
			--
		do
			lower := a_lower; upper := a_upper
		end

feature {NONE} -- Implementation

	i_th_in_range (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		local
			c: CHARACTER
		do
			c := text [i].to_character_8
			Result := lower <= c and then c <= upper
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		do
			if text.count > 0 then
				if i_th_in_range (a_offset + 1, text) then
					Result := 1
				else
					Result := Match_fail
				end
			else
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := i_th_in_range (a_offset + 1, text)
		end

	name_inserts: TUPLE
		do
			Result := [lower, upper]
		end

feature {NONE} -- Internal attributes

	lower: CHARACTER

	upper: CHARACTER

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "'%S' .. '%S'"
		end
end