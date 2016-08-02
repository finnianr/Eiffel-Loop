note
	description: "Monospace text with preformatted indentation. Corresponds to html 'pre' tag."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 7:37:07 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_FORMATTED_MONOSPACE_TEXT

inherit
	EL_FORMATTED_TEXT_BLOCK
		redefine
			set_format, append_text, append_new_line
		end

	EL_MODULE_STRING_32

create
	make

feature -- Element change

	append_text (a_text: ZSTRING)
		local
			maximum_count: INTEGER
			lines: EL_ZSTRING_LIST
			blank_line, padding, text: ZSTRING
		do
			create lines.make_with_lines (a_text)
			maximum_count := String_32.maximum_count (lines)
			create padding.make_empty
			from lines.start until lines.after loop
				create padding.make_filled (' ', maximum_count - lines.item.count)
				lines.item.append (padding)
				lines.item.enclose (' ', ' ')
				lines.forth
			end
			check
				same_size: lines.first.count = lines.last.count
			end
			create blank_line.make_filled (' ', maximum_count + 2)
			lines.put_front (blank_line)
			lines.extend (blank_line)

			text := lines.joined_lines
			paragraphs.extend ([text, format.character])
			count := count + text.count
		end

	append_new_line
		do
			Precursor
			if {PLATFORM}.is_windows then
				--	Workaround for problem where bottom right hand character of preformmatted area seems to be missing
				paragraphs.finish
				if not paragraphs.after and then paragraphs.item.text = Double_new_line then
					paragraphs.replace ([New_line, format.character])
					paragraphs.extend ([New_line, New_line_format])
				end
			end
		end

feature {NONE} -- Implementation

	set_format
		do
			format := styles.preformatted_format
		end

end