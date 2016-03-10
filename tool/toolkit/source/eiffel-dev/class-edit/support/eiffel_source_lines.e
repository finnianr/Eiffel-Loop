note
	description: "Editable source lines"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_SOURCE_LINES

inherit
	EL_ASTRING_LIST

create
	make, make_with_lines

feature -- Element change

	indent
			-- indent by 1 tab stop
		local
			l_index: INTEGER
		do
			l_index := index
			from start until after loop
				indent_line (1)
				forth
			end
			go_i_th (l_index)
		end

	indent_line (a_count: INTEGER)
		do
			item.prepend_string (tabs (a_count))
		end

	insert_line_right (line: ASTRING; tab_count: INTEGER)
		local
			l_line: ASTRING
		do
			put_right (tabs (tab_count) + line)
			l_line := i_th (index + 1)
			l_line.append_character (' ')
			l_line.append (Auto_edition_comment + "insertion")
		end

	put_auto_edit_comment_right (comment: ASTRING; tab_count: INTEGER)
		do
			put_right (tabs (tab_count) + Auto_edition_comment)
			i_th (index + 1).append (comment)
		end

	append_comment (comment: ASTRING)
			-- append comment to current item
		do
			item.append_character (' ')
			item.append (Auto_edition_comment + comment)
		end

feature {NONE} -- Implementation

	tabs (a_count: INTEGER): ASTRING
		local
			i: INTEGER
		do
			Result := Tabs_string
			if Result.count /= a_count then
				Result.wipe_out
				from i := 1 until i > a_count loop
					Result.append_character ('%T')
					i := i + 1
				end
			end
		end

feature {NONE} -- Constants

	Tabs_string: ASTRING
		once
			create Result.make_empty
		end

	Auto_edition_comment: EL_ASTRING
		once
			Result := "-- AUTO EDITION: "
		end
end
