note
	description: "Windows implementation of [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:19:04 GMT (Sunday 5th November 2023)"
	revision: "11"

class
	CAIRO_GOBJECT_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_GOBJECT_API_POINTERS]

	CAIRO_GOBJECT_C_API

	CAIRO_GOBJECT_I

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature -- Disposal

	clear (object: TYPED_POINTER [POINTER])
		do
			g_clear_object (api.clear_object, object)
		end

	unref (object: POINTER)
		do
			g_object_unref (api.object_unref, object)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libgobject-2.0-0"

	Name_prefix: STRING = "g_"

end