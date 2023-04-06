note
	description: "Editable source lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-06 9:21:36 GMT (Thursday 6th April 2023)"
	revision: "7"

class
	SOURCE_LINES

inherit
	EL_ZSTRING_LIST

create
	make, make_with_lines, make_from

convert
	make_from ({EL_ZSTRING_LIST})

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