note
	description: "Unix implementation of ${CAIRO_GLIB_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	CAIRO_GLIB_API

inherit
	CAIRO_GLIB_I
		rename
			default_create as make
		end

	EL_UNIX_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

feature -- Basic operations

	frozen clear_error (error: TYPED_POINTER [POINTER])
		-- If err or err is NULL, does nothing. Otherwise, calls g_error_free() on err and sets *err to NULL.
		-- void g_clear_error (void GError** error)
		external
			"C signature (GError **) use <glib.h>"
		alias
			"g_clear_error"
		end

feature -- Disposal

	frozen free (mem: POINTER)
		external
			"C signature (gpointer) use <glib.h>"
		alias
			"g_free"
		end

	frozen malloc (n_bytes: INTEGER): POINTER
		-- Allocates n_bytes bytes of memory. If n_bytes is 0 it returns NULL.
		-- gpointer g_malloc (gsize n_bytes)
		external
			"C signature (gsize): gpointer use <glib.h>"
		alias
			"g_malloc"
		end

	frozen realloc (mem: POINTER; n_bytes: INTEGER): POINTER
		-- Reallocates the memory pointed to by mem, so that it now has space for n_bytes bytes of memory.
		-- gpointer g_realloc (gpointer mem, gsize n_bytes)
		external
			"C signature (gpointer, gsize): gpointer use <glib.h>"
		alias
			"g_realloc"
		end

end