note
	description: "API pointers for glib-2.0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	CAIRO_GLIB_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	free: POINTER

	malloc: POINTER

	realloc: POINTER

end