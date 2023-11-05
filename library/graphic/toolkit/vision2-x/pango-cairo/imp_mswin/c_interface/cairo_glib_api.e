note
	description: "Windows implementation of [$source CAIRO_GLIB_C_API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:18:26 GMT (Sunday 5th November 2023)"
	revision: "12"

class
	CAIRO_GLIB_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_GLIB_API_POINTERS]

	CAIRO_GLIB_C_API

	EL_WINDOWS_IMPLEMENTATION

create
	make

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