note
	description: "Summary description for {EL_HTML_NUMBERED_PARAGRAPH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_FORMATTED_NUMBERED_PARAGRAPHS

inherit
	EL_FORMATTED_TEXT_BLOCK
		rename
			make as make_paragraph
		redefine
			append_text, separate_from_previous
		end

create
	make

feature {NONE} -- Initialization

	make (a_style: like styles; a_block_indent, a_index: INTEGER)
		do
			make_paragraph (a_style, a_block_indent)
			index := a_index
		end

feature -- Basic operations

	separate_from_previous (a_previous: EL_FORMATTED_TEXT_BLOCK)
			-- append new line to previous paragraph if not a header
		do
			a_previous.append_new_line
			if attached {EL_FORMATTED_TEXT_BLOCK} a_previous then
				a_previous.append_new_line
			end
		end

feature -- Access

	index: INTEGER

feature -- Element change

	append_text (a_text: ASTRING)
		do
			if paragraphs.is_empty then
				Precursor (index.out + ".")
			end
			Precursor (a_text)
		end

	set_index (a_index: like index)
		do
			index := a_index
		end

end
