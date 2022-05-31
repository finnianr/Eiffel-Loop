note
	description: "API function pointers for libpangocairo-1.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:37:00 GMT (Thursday 30th July 2020)"
	revision: "3"

class
	CAIRO_PANGO_LAYOUT_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	create_layout: POINTER

	show_layout: POINTER

	update_layout: POINTER

end
