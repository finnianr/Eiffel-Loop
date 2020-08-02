note
	description: "Unix implementation of [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:07:41 GMT (Sunday 2nd August 2020)"
	revision: "8"

class
	CAIRO_GOBJECT_IMP

inherit
	EL_DYNAMIC_MODULE [CAIRO_GOBJECT_API_POINTERS]

	CAIRO_GOBJECT_C_API

	CAIRO_GOBJECT_I

	EL_OS_IMPLEMENTATION

create
	make

feature -- Disposal

	object_unref (a_object: POINTER)
		do
			g_object_unref (api.object_unref, a_object)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libgobject-2.0-0"

	Name_prefix: STRING = "g_"

end
