note
	description: "External C functions in `<glib.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 11:27:13 GMT (Tuesday 9th January 2024)"
	revision: "11"

class
	CAIRO_GLIB_C_API

inherit
	EL_C_API

	EL_WINDOWS_IMPLEMENTATION

feature -- Access

	frozen g_clear_error (function: POINTER; error_ptr: TYPED_POINTER [POINTER])
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <glib.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (GError**))$function
				) (
					(GError**)$error_ptr
				)
			]"
		end

	frozen g_free (function, mem: POINTER)
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <glib.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (gpointer))$function
				) (
					(gpointer)$mem
				)
			]"
		end

	frozen g_malloc (function: POINTER; n_bytes: INTEGER): POINTER
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <glib.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gpointer, (gsize))$function
				) (
					(gsize)$n_bytes
				)
			]"
		end

	frozen g_realloc (function, mem: POINTER; n_bytes: INTEGER): POINTER
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <glib.h>"
		alias
			"[
				return (
					FUNCTION_CAST(gpointer, (gpointer, gsize))$function
				) (
					(gpointer)$mem, (gsize)$n_bytes
				)
			]"
		end

end