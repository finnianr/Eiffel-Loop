note
	description: "API pointers into libgdk_pixbuf"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 14:58:09 GMT (Monday 30th May 2022)"
	revision: "1"

class
	CAIRO_GDK_PIXBUF_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	new_from_file: POINTER

end