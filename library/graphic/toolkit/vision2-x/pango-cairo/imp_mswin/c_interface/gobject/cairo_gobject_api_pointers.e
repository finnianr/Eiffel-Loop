note
	description: "API function pointers for libgobject-2.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 13:36:37 GMT (Friday 31st July 2020)"
	revision: "4"

class
	CAIRO_GOBJECT_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	object_unref: POINTER

end
