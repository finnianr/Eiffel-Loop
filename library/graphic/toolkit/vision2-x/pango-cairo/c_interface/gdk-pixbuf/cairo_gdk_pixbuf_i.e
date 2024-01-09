note
	description: "Interface to routines in `<gdk-pixbuf.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 12:33:07 GMT (Tuesday 9th January 2024)"
	revision: "5"

deferred class
	CAIRO_GDK_PIXBUF_I

inherit
	EL_MEMORY_ROUTINES

	EL_OS_DEPENDENT

	CAIRO_GLIB_SHARED_API

feature -- Access

	new_from_file (file_path: FILE_PATH): POINTER
		local
			error_ptr: POINTER; path_string: CAIRO_GSTRING_I
		do
			path_string := GLIB.new_path_string (file_path)
			Result := new_pixbuf_from_file (path_string.item, $error_ptr)
			GLIB.handle_error (error_ptr, $error_ptr)
		end

feature -- Measurement

	height (a_pixbuf: POINTER): INTEGER_32
		deferred
		end

	width (a_pixbuf: POINTER): INTEGER_32
		deferred
		end

feature -- Disposal

	unref (pixbuf: POINTER)
		deferred
		end

feature {NONE} -- Implementation

	new_pixbuf_from_file (filename: POINTER; error: TYPED_POINTER [POINTER]): POINTER
		deferred
		end
end