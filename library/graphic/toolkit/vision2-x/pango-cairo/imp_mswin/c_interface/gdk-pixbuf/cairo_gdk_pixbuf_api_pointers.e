note
	description: "API pointers into libgdk_pixbuf"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-01 15:50:22 GMT (Wednesday 1st June 2022)"
	revision: "2"

class
	CAIRO_GDK_PIXBUF_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	get_height: POINTER

	get_width: POINTER

	new_from_file_utf8: POINTER

end