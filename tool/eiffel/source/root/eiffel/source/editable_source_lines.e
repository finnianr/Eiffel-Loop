note
	description: "Editable source lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 18:15:06 GMT (Wednesday 7th May 2025)"
	revision: "10"

class
	EDITABLE_SOURCE_LINES

inherit
	EL_ZSTRING_LIST

	EL_ZSTRING_CONSTANTS

create
	make, make_empty, make_from, make_feature, make_with_lines

feature {NONE} -- Initialization

	make_feature (source_lines: READABLE_STRING_GENERAL)
		do
			make_with_lines (source_lines)
			extend (Empty_string)
		end

feature -- Element change

	append_comment (comment: STRING)
			-- append comment to current item
		do
			item.append_character (' ')
			item.append_string_general (Auto_edition_comment + comment)
		end

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
			put_right (tab_string (tab_count - 1) + Auto_edition_comment)
			i_th (index + 1).append_string_general (comment)
		end

feature {NONE} -- Constants

	Auto_edition_comment: ZSTRING
		once
			Result := "-- AUTO EDITION: "
		end
end