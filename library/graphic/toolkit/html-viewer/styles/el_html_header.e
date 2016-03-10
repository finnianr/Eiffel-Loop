note
	description: "Summary description for {EL_HTML_HEADER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-06 10:21:21 GMT (Saturday 6th July 2013)"
	revision: "2"

class
	EL_HTML_HEADER

inherit
	EL_HTML_PARAGRAPH
		rename
			make as make_paragraph
		redefine
			set_format, separate_from_previous
		end

create
	make

feature {NONE} -- Initialization

	make (a_style: like style; a_block_indent, a_level: INTEGER)
		do
			level := a_level
			make_paragraph (a_style, a_block_indent)
		end

feature -- Access

	level: INTEGER

feature -- Basic operations

	separate_from_previous (a_previous: EL_HTML_PARAGRAPH)
		do
		end

feature {NONE} -- Implementation

	set_format
		do
			format := style.heading_formats [level]
		end

end
