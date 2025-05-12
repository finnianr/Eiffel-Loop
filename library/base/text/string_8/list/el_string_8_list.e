note
	description: "List of strings of type ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 9:03:56 GMT (Monday 12th May 2025)"
	revision: "31"

class
	EL_STRING_8_LIST

inherit
	EL_STRING_LIST [STRING]
		redefine
			add_to_checksum, item_indent, new_string, tab_string
		end

	EL_CHARACTER_8_CONSTANTS

create
	make, make_empty, make_with_lines, make_filled, make_from_special,
	make_from, make_from_iterable, make_from_substrings, make_from_array,
	make_from_tuple, make_from_general, make_paragraphs,
	make_split, make_adjusted_split, make_word_split, make_comma_split,
	make_multiline_words

convert
	make_from_array ({ARRAY [STRING]}), make_comma_split ({STRING}), make_from_tuple ({TUPLE})

feature {NONE} -- Initialization

	make_multiline_words (str: STRING_8; word_separator: CHARACTER_8; a_adjustments: INTEGER)
		-- list of words from multiple lines with words separated by `word_separator'
		-- with word trailing/leading whitespace adjusted according to constants in class `EL_SIDE'
		-- (0 for none)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		local
			line_list, word_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
			word_count: INTEGER
		do
			create line_list.make_shared_adjusted (str, '%N', 0)
			across line_list as list loop
				word_count := word_count + list.item.occurrences (word_separator) + 1
			end
			make (word_count)
			create word_list.make_empty
			across line_list as line loop
				word_list.wipe_out
				word_list.fill (line.item, word_separator, a_adjustments)
				across word_list as list loop
					extend (list.item)
				end
			end
		end

feature -- Access

	item_indent: INTEGER
		do
			Result := super_8 (item).leading_occurrences ('%T')
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

end