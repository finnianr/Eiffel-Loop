note
	description: "Editable source lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-19 7:27:16 GMT (Thursday 19th September 2024)"
	revision: "9"

class
	EDITABLE_SOURCE_LINES

inherit
	EL_ZSTRING_LIST

create
	make, make_empty, make_with_lines, make_filled, make_from_special,
	make_from, make_from_substrings, make_from_if, make_from_array, make_from_list,
	make_from_tuple, make_from_general, make_split, make_adjusted_split, make_word_split, make_comma_split

feature -- Element change

	insert_line_right (a_line: STRING; tab_count: INTEGER)
		local
			line: ZSTRING
		do
			put_right (tab_string (tab_count) + a_line)
			line := i_th (index + 1)
			line.append_character (' ')
			line.append (Auto_edition_comment + "insertion")
		end

	put_auto_edit_comment_right (comment: STRING; tab_count: INTEGER)
		do
			put_right (tab_string (tab_count) + Auto_edition_comment)
			i_th (index + 1).append_string_general (comment)
		end

	append_comment (comment: STRING)
			-- append comment to current item
		do
			item.append_character (' ')
			item.append_string_general (Auto_edition_comment + comment)
		end

feature {NONE} -- Constants

	Auto_edition_comment: ZSTRING
		once
			Result := "-- AUTO EDITION: "
		end
end