note
	description: "List of strings of type ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-28 8:53:48 GMT (Tuesday 28th January 2025)"
	revision: "24"

class
	EL_STRING_8_LIST

inherit
	EL_STRING_LIST [STRING]
		redefine
			add_to_checksum, item_indent, new_string, tab_string
		end

	EL_CHARACTER_8_CONSTANTS

	EL_SHARED_STRING_8_CURSOR

create
	make, make_empty, make_with_lines, make_filled, make_from_special,
	make_from, make_from_substrings, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING]}), make_comma_split ({STRING}), make_from_tuple ({TUPLE})

feature -- Access

	item_indent: INTEGER
		do
			if attached cursor_8 (item) as c8 then
				Result := c8.leading_occurrences ('%T')
			end
		end

feature -- Basic operations

	display_grouped (log: EL_LOGGABLE)
		-- display strings grouped on each line by first character in alphabetical order
		local
			first_character: CHARACTER
		do
			if count > 0 and then attached twin as sorted then
				sorted.sort (True)
				if sorted.first.count > 0 then
					first_character := sorted.first [1]
				end
				across sorted as list loop
					if attached list.item as str then
						if list.cursor_index > 1 then
							if str.count > 0 and then first_character /= str [1] then
								log.put_new_line
								first_character := str [1]
							else
								log.put_string (Semicolon_space)
							end
						end
						log.put_string (str)
					end
				end
				log.put_new_line
			end
		end

feature {NONE} -- Implementation

	add_to_checksum (crc: like crc_generator; str: STRING_8)
		do
			crc.add_string_8 (str)
		end

	new_string (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := general.to_string_8
		end

	tab_string (a_count: INTEGER): STRING_8
		do
			Result := tab * a_count
		end

feature {NONE} -- Constants

	Semicolon_space: STRING = "; "

end