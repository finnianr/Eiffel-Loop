note
	description: "Unescape strings conforming to ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 15:57:29 GMT (Thursday 5th January 2023)"
	revision: "7"

class
	EL_STRING_32_UNESCAPER

inherit
	EL_STRING_GENERAL_UNESCAPER [READABLE_STRING_32, STRING_32]

	EL_STRING_32_CONSTANTS

	EL_SHARED_STRING_32_CURSOR

create
	make

feature -- Access

	unescaped (str: READABLE_STRING_32): STRING_32
		local
			l_area: SPECIAL [CHARACTER_32]
		do
			l_area := unescaped_array (str)
			create Result.make (l_area.count)
			Result.area.copy_data (l_area, 0, 0, l_area.count)
			Result.set_count (l_area.count)
		end

feature -- Basic operations

	unescape (str: STRING_32)
		do
			if str.has_code (escape_code) then
				str.share (unescaped (str))
			end
		end

	unescape_into (str: READABLE_STRING_32; output: STRING_32)
		local
			l_area: SPECIAL [CHARACTER_32]; old_count, new_count: INTEGER
		do
			l_area := unescaped_array (str)
			old_count := output.count; new_count := old_count + l_area.count
			output.grow (new_count)
			output.area.copy_data (l_area, 0, old_count, l_area.count)
			output.set_count (new_count)
		end

feature {NONE} -- Implementation

	unescaped_array (str: READABLE_STRING_32): SPECIAL [CHARACTER_32]
		local
			i, seq_count, first_index, last_index: INTEGER
			l_area: SPECIAL [CHARACTER_32]
			char_i, esc_char: CHARACTER_32
		do
			esc_char := escape_code.to_character_32
			if attached cursor_32 (str) as l_cursor then
				l_area := l_cursor.area
				first_index := l_cursor.area_first_index
				last_index := l_cursor.area_last_index
			end

			create Result.make_empty (str.count)
			from i := first_index until i > last_index loop
				char_i := l_area.item (i)
				if char_i = esc_char then
					seq_count := sequence_count (str, i + 2)
					if seq_count.to_boolean then
						char_i := unescaped_code (i + 2, seq_count).to_character_32
					end
				else
					seq_count := 0
				end
				Result.extend (char_i)
				i := i + seq_count + 1
			end
		end

end