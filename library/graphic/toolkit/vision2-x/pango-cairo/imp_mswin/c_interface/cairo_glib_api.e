note
	description: "Windows implementation of ${CAIRO_GLIB_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 11:37:20 GMT (Tuesday 9th January 2024)"
	revision: "13"

class
	CAIRO_GLIB_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_GLIB_API_POINTERS]

	CAIRO_GLIB_C_API

	CAIRO_GLIB_I

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature -- Basic operations

	clear_error (error_ptr: TYPED_POINTER [POINTER])
		-- If err or err is NULL, does nothing. Otherwise, calls g_error_free() on err and sets *err to NULL.
		do
			g_clear_error (api.clear_error, error_ptr)
		end

feature -- Disposal

	free (mem: POINTER)
		do
			g_free (api.free, mem)
		end

	malloc (n_bytes: INTEGER): POINTER
		do
			Result := g_malloc (api.malloc, n_bytes)
		end

	realloc (mem: POINTER; n_bytes: INTEGER): POINTER
		do
			Result := g_realloc (api.realloc, mem, n_bytes)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libglib-2.0-0"

	Name_prefix: STRING = "g_"

end