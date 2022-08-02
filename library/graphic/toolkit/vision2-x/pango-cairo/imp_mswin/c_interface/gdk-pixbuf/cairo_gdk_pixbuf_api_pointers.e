note
	description: "API pointers into libgdk_pixbuf"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-01 14:08:03 GMT (Monday 1st August 2022)"
	revision: "3"

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