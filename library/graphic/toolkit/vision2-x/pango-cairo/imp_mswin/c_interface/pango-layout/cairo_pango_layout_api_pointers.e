Note
	description: "API function pointers for libpangocairo-1.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	CAIRO_PANGO_LAYOUT_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	create_context: POINTER

	create_layout: POINTER

	font_map_get_default: POINTER

	show_layout: POINTER

	update_layout: POINTER

end
