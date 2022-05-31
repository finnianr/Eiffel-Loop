note
	description: "Gobject c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:42:12 GMT (Sunday 2nd August 2020)"
	revision: "7"

class
	CAIRO_GOBJECT_C_API

inherit
	EL_OS_IMPLEMENTATION

feature -- Disposal

	g_object_unref (fn_ptr, object: POINTER)
			-- void g_object_unref (gpointer object);
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
