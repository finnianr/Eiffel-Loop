note
	description: "Summary description for {EL_GTK_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_GOBJECT_API

inherit
	EL_DYNAMIC_MODULE

	EL_GOBJECT_C_API
		undefine
			dispose
		end

	EL_GOBJECT_I

create
	make

feature -- Access

--	widget_get_snapshot (a_widget, a_rectangle: POINTER): POINTER
--		do
--		end

feature -- Disposal

	object_unref (a_object: POINTER)
		do
			g_object_unref (pointer_g_object_unref, a_object)
		end

feature {NONE} -- Implementation

	assign_pointers
		do
			pointer_g_object_unref := function_pointer ("object_unref")
		end

	pointer_g_object_unref: POINTER

feature {NONE} -- Constants

	Module_name: STRING = "libgobject-2.0-0"

	Name_prefix: STRING = "g_"

end
