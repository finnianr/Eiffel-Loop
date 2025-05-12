note
	description: "Monospace text with preformatted indentation. Corresponds to html 'pre' tag."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 6:15:10 GMT (Monday 12th May 2025)"
	revision: "8"

class
	EL_FORMATTED_MONOSPACE_TEXT

inherit
	EL_FORMATTED_TEXT_BLOCK
		redefine
			set_format, append_text, append_new_line
		end

create
	make

feature -- Element change

	append_text (a_text: ZSTRING)
		local
			maximum_count: INTEGER; lines: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (a_text)
			maximum_count := lines.longest_count
			from lines.start until lines.after loop
				lines.item.append (space * (maximum_count - lines.item.count))
				lines.item.enclose (' ', ' ')
				lines.forth
			end
			check
				same_size: lines.count > 0 implies lines.first.count = lines.last.count
			end

			lines.put_front (space * (maximum_count + 2))
			lines.extend (space * (maximum_count + 2))

			extend (lines.joined_lines, format.character)
			character_count := character_count + last_text.count
		end

	append_new_line
		do
			Precursor
			if {PLATFORM}.is_windows then
				--	Workaround for problem where bottom right hand character of preformmatted area seems to be missing
				if count > 0 and then last_text = New_line * 2 then
					finish
					replace (New_line, format.character)
					extend (New_line, New_line_format)
				end
			end
		end

feature {NONE} -- Implementation

	set_format
		do
			format := styles.preformatted_format
		end

end