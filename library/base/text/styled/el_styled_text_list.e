note
	description: "Styled text list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-02 10:43:15 GMT (Wednesday 2nd September 2020)"
	revision: "1"

class
	EL_STYLED_TEXT_LIST [S -> READABLE_STRING_GENERAL]

inherit
	EL_ARRAYED_MAP_LIST [INTEGER, S]
		rename
			first_key as first_style,
			first_value as first_text,
			item_key as item_style,
			item_value as item_text,
			last_key as last_style,
			last_value as last_text
		redefine
			extend, put_front
		end

	EL_TEXT_STYLE
		export
			{NONE} all
			{ANY} is_valid_style
		undefine
			copy, is_equal
		end

create
	make, make_regular, make_filled, make_from_list, make_empty, make_from_array

feature {NONE} -- Initialization

	make_regular (text: like item_text)
		do
			make (1)
			extend (Regular, text)
		end

feature -- Element change

	extend (style: like item_style; text: like item_text)
		require else
			valid_style: is_valid_style (style)
		do
			map_extend ([style, text])
		end

	put_front (style: like item_style; text: like item_text)
		require else
			valid_style: is_valid_style (style)
		do
			map_put_front ([style, text])
		end

end
