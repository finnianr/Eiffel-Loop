note
	description: "Editable source lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 12:17:20 GMT (Friday 4th March 2016)"
	revision: "1"

class
	EIFFEL_SOURCE_LINES

inherit
	EL_ZSTRING_LIST
		redefine
			tab_string
		end

create
	make, make_with_lines

feature -- Element change

	insert_line_right (line: ZSTRING; tab_count: INTEGER)
		local
			l_line: ZSTRING
		do
			put_right (tab_string (tab_count) + line)
			l_line := i_th (index + 1)
			l_line.append_character (' ')
			l_line.append (Auto_edition_comment + "insertion")
		end

	put_auto_edit_comment_right (comment: ZSTRING; tab_count: INTEGER)
		do
			put_right (tab_string (tab_count) + Auto_edition_comment)
			i_th (index + 1).append (comment)
		end

	append_comment (comment: ZSTRING)
			-- append comment to current item
		do
			item.append_character (' ')
			item.append (Auto_edition_comment + comment)
		end

feature {NONE} -- Implementation

	tab_string (a_count: INTEGER): ZSTRING
		do
			create Result.make_filled (Tabulation.to_character_8, a_count)
		end

feature {NONE} -- Constants

	Auto_edition_comment: ZSTRING
		once
			Result := "-- AUTO EDITION: "
		end
end