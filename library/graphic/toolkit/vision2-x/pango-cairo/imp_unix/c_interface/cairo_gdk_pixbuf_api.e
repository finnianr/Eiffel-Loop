note
	description: "Unix implementation of [$source CAIRO_GDK_PIXBUF_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:23:41 GMT (Tuesday 9th January 2024)"
	revision: "5"

class
	CAIRO_GDK_PIXBUF_API

inherit
	CAIRO_GDK_PIXBUF_I
		rename
			default_create as make
		end

	EL_UNIX_IMPLEMENTATION
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

feature -- Disposal

	unref (pixbuf: POINTER)
		do
			{EL_GTK_2_C_API}.gdk_pixbuf_unref (pixbuf)
		end

feature {NONE} -- Implementation

	new_pixbuf_from_file (file_path: POINTER; error: TYPED_POINTER [POINTER]): POINTER
		do
			Result := {GTK}.gdk_pixbuf_new_from_file (file_path, error)
		end

end