note
	description: "Gobject c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:34:19 GMT (Thursday 30th July 2020)"
	revision: "6"

class
	CAIRO_GOBJECT_C_API

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
