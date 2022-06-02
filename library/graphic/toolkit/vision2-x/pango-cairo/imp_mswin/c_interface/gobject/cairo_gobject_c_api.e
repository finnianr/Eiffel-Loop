note
	description: "Gobject c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 13:12:12 GMT (Thursday 2nd June 2022)"
	revision: "8"

class
	CAIRO_GOBJECT_C_API

inherit
	EL_C_API_ROUTINES

	EL_OS_IMPLEMENTATION

feature -- Disposal

	frozen g_clear_object (function: POINTER; object: TYPED_POINTER [POINTER])
			-- void g_clear_object (volatile GObject **object_ptr);
		require
			function_attached: is_attached (function)
		external
			"C inline use <gtk/gtk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (GObject **))$function
				) (
					(GObject **)$object
				)
			]"
		end

	frozen g_object_unref (function, object: POINTER)
			-- void g_object_unref (gpointer object);
		require
			function_attached: is_attached (function)
		external
			"C inline use <gtk/gtk.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (gpointer))$function
				) (
					(gpointer)$object
				)
			]"
		end

end