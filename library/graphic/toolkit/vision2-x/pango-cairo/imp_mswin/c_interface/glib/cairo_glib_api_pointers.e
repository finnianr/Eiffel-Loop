note
	description: "API pointers for glib-2.0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 11:24:29 GMT (Tuesday 9th January 2024)"
	revision: "8"

class
	CAIRO_GLIB_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	clear_error: POINTER

	free: POINTER

	malloc: POINTER

	realloc: POINTER

end