note
	description: "API function pointers for libgobject-2.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 13:11:17 GMT (Thursday 2nd June 2022)"
	revision: "5"

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