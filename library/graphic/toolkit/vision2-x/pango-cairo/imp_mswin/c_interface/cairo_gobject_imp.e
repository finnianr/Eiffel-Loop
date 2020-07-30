note
	description: "Unix implementation of [$source CAIRO_GOBJECT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:34:28 GMT (Thursday 30th July 2020)"
	revision: "7"

class
	CAIRO_GOBJECT_IMP

inherit
	EL_DYNAMIC_MODULE [CAIRO_GOBJECT_API_POINTERS]

	CAIRO_GOBJECT_C_API

	CAIRO_GOBJECT_I

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
