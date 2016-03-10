note
	description: "Summary description for {EL_HTML_NUMBERED_PARAGRAPH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-26 15:31:52 GMT (Sunday 26th May 2013)"
	revision: "2"

class
	EL_HTML_NUMBERED_PARAGRAPH

inherit
	EL_HTML_PARAGRAPH
		rename
			make as make_paragraph
		redefine
			append_text, separate_from_previous
		end

create
	make

feature {NONE} -- Initialization

	make (a_style: like style; a_block_indent, a_index: INTEGER)
		do
			make_paragraph (a_style, a_block_indent)
			index := a_index
		end

feature -- Basic operations

	separate_from_previous (a_previous: EL_HTML_PARAGRAPH)
			-- append new line to previous paragraph if not a header
		do
			if Typing.type_of (a_previous) ~ {EL_HTML_PARAGRAPH} then
				a_previous.append_new_line
			end
		end

feature -- Access

	index: INTEGER

feature -- Element change

	append_text (a_text: like text)
		do
			if text.is_empty then
				Precursor (index.out + ".")
			end
			Precursor (a_text)
		end

end
