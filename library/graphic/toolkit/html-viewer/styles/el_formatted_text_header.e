note
	description: "Summary description for {EL_HTML_HEADER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:22:17 GMT (Saturday 26th December 2015)"
	revision: "5"

class
	EL_FORMATTED_TEXT_HEADER

inherit
	EL_FORMATTED_TEXT_BLOCK
		rename
			make as make_paragraph
		redefine
			set_format, separate_from_previous
		end

create
	make

feature {NONE} -- Initialization

	make (a_style: like styles; a_block_indent, a_level: INTEGER)
		do
			level := a_level
			make_paragraph (a_style, a_block_indent)
		end

feature -- Access

	level: INTEGER

	text: ZSTRING
		do
			Result := paragraphs.first.text
		end

feature -- Basic operations

	separate_from_previous (a_previous: EL_FORMATTED_TEXT_BLOCK)
		do
			a_previous.append_new_line
			if attached {EL_FORMATTED_MONOSPACE_TEXT} a_previous then
				a_previous.append_new_line
			end
		end

feature {NONE} -- Implementation

	set_format
		do
			format := styles.heading_formats [level]
		end

end
