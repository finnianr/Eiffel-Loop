note
	description: "Summary description for {EL_HTML_PREFORMATTED_PARAGRAPH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:07:58 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_HTML_PREFORMATTED_PARAGRAPH

inherit
	EL_HTML_PARAGRAPH
		redefine
			set_format, append_text--, separate_from_previous
		end

create
	make

feature -- Element change

	append_text (a_text: like text)
		local
			maximum_count: INTEGER
			lines: EL_LINKED_STRING_LIST [EL_ASTRING]
			blank_line: STRING
		do
			create lines.make_with_lines (a_text)
			maximum_count := String.maximum_count (lines)
			create blank_line.make_empty
			if a_text.has ('%N') then
--				lines.put_front (blank_line)
--				lines.extend (blank_line.string)
			end
			from lines.start until lines.after loop
				create blank_line.make_filled (' ', maximum_count - lines.item.count)
				lines.item.append (blank_line)
				lines.replace (String.bookended (lines.item, ' ', ' '))
				lines.forth
			end
			Precursor (lines.joined_lines)
		end

feature -- Basic operations

--	separate_from_previous (a_previous: EL_HTML_PARAGRAPH)
--			-- append new line to previous paragraph if not a header
--		do
--		end

feature {NONE} -- Implementation

	set_format
		do
			format := style.preformatted_format
		end
end