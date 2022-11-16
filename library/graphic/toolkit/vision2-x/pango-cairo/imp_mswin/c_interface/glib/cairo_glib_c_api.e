note
	description: "External C functions in `<glib.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	CAIRO_GLIB_C_API

inherit
	EL_C_API_ROUTINES

	EL_OS_IMPLEMENTATION

feature -- Access

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