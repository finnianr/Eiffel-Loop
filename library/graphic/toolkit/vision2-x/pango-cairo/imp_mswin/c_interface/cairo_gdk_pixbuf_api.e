note
	description: "Windows implementation of ${CAIRO_GDK_PIXBUF_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	CAIRO_GDK_PIXBUF_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_GDK_PIXBUF_API_POINTERS]

	CAIRO_GDK_PIXBUF_I

	CAIRO_GDK_PIXBUF_C_API
		undefine
			dispose
		end

create
	make

feature -- Measurement

	height (pixbuf: POINTER): INTEGER
		do
			Result := gdk_pixbuf_get_height (api.get_height, pixbuf)
		end

	width (pixbuf: POINTER): INTEGER
		do
			Result := gdk_pixbuf_get_width (api.get_width, pixbuf)
		end

feature -- Disposal

	unref (pixbuf: POINTER)
		do
			gdk_pixbuf_unref (api.unref, pixbuf)
		end

feature {NONE} -- Implementation

	new_pixbuf_from_file (filename: POINTER; error: TYPED_POINTER [POINTER]): POINTER
		do
			Result := gdk_pixbuf_new_from_file_utf8 (api.new_from_file_utf8, filename, error)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libgdk_pixbuf-2.0-0"

	Name_prefix: STRING = "gdk_pixbuf_"
end