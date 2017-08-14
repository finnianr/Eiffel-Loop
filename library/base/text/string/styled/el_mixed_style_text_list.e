note
	description: "[
		list of strings that should be rendered with either a regular, bold or fixed font
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:26:35 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_MIXED_STYLE_TEXT_LIST

inherit
	ARRAYED_LIST [EL_STYLED_TEXT]

create
	make, make_from_array

end
