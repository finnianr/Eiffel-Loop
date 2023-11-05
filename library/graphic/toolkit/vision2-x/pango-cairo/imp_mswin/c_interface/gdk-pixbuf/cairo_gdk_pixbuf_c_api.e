note
	description: "Windows implementation of routines from `gdk-pixbuf.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:19:56 GMT (Sunday 5th November 2023)"
	revision: "5"

class
	CAIRO_GDK_PIXBUF_C_API

inherit
	EL_MEMORY

	EL_WINDOWS_IMPLEMENTATION

feature -- Access

	frozen gdk_pixbuf_get_height (function, pixbuf: POINTER): INTEGER_32
		-- int gdk_pixbuf_get_height (const GdkPixbuf *pixbuf);
		external
			"C inline use <gdk-pixbuf/gdk-pixbuf.h>"
		alias
			"[
				return (
					FUNCTION_CAST(int, (GdkPixbuf *))$function
				) (
					(const GdkPixbuf * *)$pixbuf
				)
			]"
		end

	frozen gdk_pixbuf_get_width (function, pixbuf: POINTER): INTEGER_32
		-- int gdk_pixbuf_get_width (const GdkPixbuf *pixbuf);
		external
			"C inline use <gdk-pixbuf/gdk-pixbuf.h>"
		alias
			"[
				return (
					FUNCTION_CAST(int, (GdkPixbuf *))$function
				) (
					(const GdkPixbuf * *)$pixbuf
				)
			]"
		end

	frozen gdk_pixbuf_new_from_file_utf8 (function, filename: POINTER; error: TYPED_POINTER [POINTER]): POINTER
			-- GdkPixbuf *gdk_pixbuf_new_from_file (const char *filename, GError **error);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <gdk-pixbuf/gdk-pixbuf.h>"
		alias
			"[
				return (
					FUNCTION_CAST(GdkPixbuf *, (const char *, GError **))$function
				) (
					(const char *)$filename, (GError **)$error
				)
			]"
		end

	frozen gdk_pixbuf_unref (fn_ptr, object: POINTER)
			-- void gdk_pixbuf_unref (GdkPixbuf* pixbuf)
		external
			"C inline use <gdk-pixbuf/gdk-pixbuf.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (GdkPixbuf*))$fn_ptr
				) (
					(GdkPixbuf*)$object
				)
			]"
		end

end