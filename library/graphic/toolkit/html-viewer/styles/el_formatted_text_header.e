note
	description: "Formatted text header"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 14:49:44 GMT (Thursday 17th August 2023)"
	revision: "7"

class
	EL_FORMATTED_TEXT_HEADER

inherit
	EL_FORMATTED_TEXT_BLOCK
		rename
			make as make_paragraph,
			first_text as text
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