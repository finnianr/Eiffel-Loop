note
	description: "API function pointers for libgobject-2.0-0"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GOBJECT_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	object_unref: POINTER

end
