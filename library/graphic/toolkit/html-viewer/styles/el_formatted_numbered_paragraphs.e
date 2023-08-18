note
	description: "Formatted numbered paragraphs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 14:47:58 GMT (Thursday 17th August 2023)"
	revision: "8"

class
	EL_FORMATTED_NUMBERED_PARAGRAPHS

inherit
	EL_FORMATTED_BULLETED_PARAGRAPHS
		rename
			make as make_paragraph,
			new_bullet_text as new_numbered_text,
			index as item_index
		redefine
			new_numbered_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_style: like styles; a_block_indent, a_index: INTEGER)
		do
			make_paragraph (a_style, a_block_indent)
			index := a_index
		end

feature -- Access

	index: INTEGER

feature -- Element change

	set_index (a_index: like index)
		do
			index := a_index
		end

feature {NONE} -- Implementation

	new_numbered_text: ZSTRING
		do
			Result := index.out + Dot * 1
		end
end