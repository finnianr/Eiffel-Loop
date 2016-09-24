note
	description: "API function pointers for libgobject-2.0-0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-21 14:14:56 GMT (Wednesday 21st September 2016)"
	revision: "1"

class
	EL_GOBJECT_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	object_unref: POINTER

end
