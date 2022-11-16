note
	description: "API function pointers for libgobject-2.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	CAIRO_GOBJECT_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	clear_object: POINTER

	object_unref: POINTER

end