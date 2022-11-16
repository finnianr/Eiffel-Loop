note
	description: "Interface to routines in `<gdk-pixbuf.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	CAIRO_GDK_PIXBUF_I

inherit
	EL_C_API_ROUTINES

feature -- Access

	new_from_file (file_path: FILE_PATH): POINTER
		local
			error_ptr: POINTER; path_str: CAIRO_GSTRING_I
			exception: CAIRO_EXCEPTION
		do
			create {CAIRO_GSTRING_IMP} path_str.make_from_file_path (file_path)
			Result := new_pixbuf_from_file (path_str.item, $error_ptr)
			if is_attached (error_ptr) then
				create exception.make ({STRING_32} "Error loading " + file_path.base, error_ptr)
				exception.raise
			end
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