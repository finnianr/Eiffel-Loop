note
	description: "Cairo Glib API interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 14:47:21 GMT (Tuesday 9th January 2024)"
	revision: "1"

deferred class
	CAIRO_GLIB_I

inherit
	EL_MEMORY_ROUTINES

	EL_OS_DEPENDENT

feature -- Basic operations

	clear_error (error: TYPED_POINTER [POINTER])
		-- If err or err is NULL, does nothing. Otherwise, calls g_error_free() on err and sets *err to NULL.
		deferred
		end

	handle_error (error_ptr: POINTER; error_ptr_address: TYPED_POINTER [POINTER])
		-- clears error at `error_ptr_address' and raises Cairo exception
		local
			exception: CAIRO_EXCEPTION
		do
			if is_attached (error_ptr) then
				create exception.make (new_error_string (error_ptr_address))
				clear_error (error_ptr_address)
				exception.raise
			end
		end

feature -- Disposal

	free (mem: POINTER)
		deferred
		end

	malloc (n_bytes: INTEGER): POINTER
		deferred
		end

	realloc (mem: POINTER; n_bytes: INTEGER): POINTER
		deferred
		end

feature -- Access

	frozen error_message (error: TYPED_POINTER [POINTER]): POINTER
		external
			"C inline use <glib.h>"
		alias
			"[
				GError** p_err = (GError**) $error;
				return (*p_err)->message;
			]"
		end

feature -- Factory

	new_error_string (error: TYPED_POINTER [POINTER]): CAIRO_GSTRING_I
		do
			create {CAIRO_GSTRING_IMP} Result.share_from_pointer (error_message (error))
		end

	new_path_string (path: EL_PATH): CAIRO_GSTRING_I
		do
			create {CAIRO_GSTRING_IMP} Result.make_from_path (path)
		end

end