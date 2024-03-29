note
	description: "API function pointers for libpangocairo-1.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-04 8:31:06 GMT (Wednesday 4th October 2023)"
	revision: "5"

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