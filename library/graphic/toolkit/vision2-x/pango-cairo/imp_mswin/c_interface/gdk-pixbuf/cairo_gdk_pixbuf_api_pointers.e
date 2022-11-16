note
	description: "API pointers into libgdk_pixbuf"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	CAIRO_GDK_PIXBUF_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	get_height: POINTER

	get_width: POINTER

	unref: POINTER

	new_from_file_utf8: POINTER

end