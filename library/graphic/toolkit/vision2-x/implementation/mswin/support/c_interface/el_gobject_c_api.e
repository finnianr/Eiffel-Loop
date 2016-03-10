note
	description: "Summary description for {EL_GTK_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_GOBJECT_C_API

inherit
	EL_MEMORY

feature -- Disposal

	g_object_unref (fn_ptr, object: POINTER)
			-- void g_object_unref (gpointer object);
		require
			fn_ptr_attached: is_attached (fn_ptr)
		external
			"C inline use <gtk/gtk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (gpointer))$fn_ptr
				) (
					(gpointer)$object
				)
			]"
		end
end
