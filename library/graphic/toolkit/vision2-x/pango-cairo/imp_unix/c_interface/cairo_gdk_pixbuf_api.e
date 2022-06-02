note
	description: "Unix implementation of [$source CAIRO_GDK_PIXBUF_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-01 17:31:07 GMT (Wednesday 1st June 2022)"
	revision: "2"

class
	CAIRO_GDK_PIXBUF_API

inherit
	CAIRO_GDK_PIXBUF_I
		rename
			default_create as make
		end

create
	make

feature -- Measurement

	height (a_pixbuf: POINTER): INTEGER_32
		do
			Result := {GTK}.gdk_pixbuf_get_height (a_pixbuf)
		end

	width (a_pixbuf: POINTER): INTEGER_32
		do
			Result := {GTK}.gdk_pixbuf_get_width (a_pixbuf)
		end

feature {NONE} -- Implementation

	new_pixbuf_from_file (file_path: POINTER; error: TYPED_POINTER [POINTER]): POINTER
		do
			Result := {GTK}.gdk_pixbuf_new_from_file (file_path, error)
		end

end