note
	description: "Unescape strings conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 8:56:26 GMT (Thursday 3rd April 2025)"
	revision: "10"

class
	EL_STRING_8_UNESCAPER

inherit
	EL_STRING_GENERAL_UNESCAPER [READABLE_STRING_8, STRING_8]

	EL_STRING_8_CONSTANTS

	EL_SHARED_STRING_8_CURSOR

create
	make

feature -- Access

	unescaped (str: READABLE_STRING_8): STRING_8
		local
			l_area: SPECIAL [CHARACTER_8]
		do
			l_area := unescaped_array (str)
			create Result.make (l_area.count)
			Result.area.copy_data (l_area, 0, 0, l_area.count)
			Result.set_count (l_area.count)
		end

feature -- Basic operations

	unescape (str: STRING_8)
		do
			if str.has_code (escape_code) then
				str.share (unescaped (str))
			end
		end

	unescape_into (str: READABLE_STRING_8; output: STRING_8)
		local
			l_area: SPECIAL [CHARACTER_8]; old_count, new_count: INTEGER
		do
			l_area := unescaped_array (str)
			old_count := output.count; new_count := old_count + l_area.count
			output.grow (new_count)
			output.area.copy_data (l_area, 0, old_count, l_area.count)
			output.set_count (new_count)
		end

feature {NONE} -- Implementation

	unescaped_array (str: READABLE_STRING_8): SPECIAL [CHARACTER_8]
		local
			i, seq_count, first_index, last_index: INTEGER
			l_area: SPECIAL [CHARACTER_8]
			char_i, esc_char: CHARACTER_8
		do
			esc_char := escape_code.to_character_8
			if attached cursor_8 (str) as l_cursor then
				l_area := l_cursor.area
				first_index := l_cursor.index_lower
				last_index := l_cursor.index_upper
			end

			create Result.make_empty (str.count)
			from i := first_index until i > last_index loop
				char_i := l_area.item (i)
				if char_i = esc_char then
					seq_count := sequence_count (str, i + 2)
					if seq_count.to_boolean then
						char_i := unescaped_code (i + 2, seq_count).to_character_8
					end
				else
					seq_count := 0
				end
				Result.extend (char_i)
				i := i + seq_count + 1
			end
		end


end