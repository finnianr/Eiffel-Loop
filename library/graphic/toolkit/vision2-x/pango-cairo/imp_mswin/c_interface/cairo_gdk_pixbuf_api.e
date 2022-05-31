note
	description: "Windows implementation of [$source CAIRO_GDK_PIXBUF_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 16:41:18 GMT (Monday 30th May 2022)"
	revision: "1"

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

feature -- Access

	new_from_file (filename: POINTER; error: TYPED_POINTER [POINTER]): POINTER
		do
			Result := gdk_pixbuf_new_from_file (api.new_from_file, filename, error)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libgdk_pixbuf-2.0-0"

	Name_prefix: STRING = "gdk_pixbuf"
end