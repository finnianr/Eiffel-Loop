note
	description: "Unix implementation of [$source CAIRO_GDK_PIXBUF_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 10:13:20 GMT (Tuesday 31st May 2022)"
	revision: "1"

class
	CAIRO_GDK_PIXBUF_API

inherit
	CAIRO_GDK_PIXBUF_I
		rename
			default_create as make
		end

	EL_MODULE_EXCEPTION
		rename
			default_create as make
		end

	EL_GTK_2_C_API
		rename
			default_create as make
		export
			{NONE} all
		end

create
	make

feature -- Access

	new_from_file (file_path: FILE_PATH): POINTER
		local
			error_ptr: POINTER; path_str, error: CAIRO_GSTRING_I
		do
			create {CAIRO_GSTRING_IMP} path_str.make_from_path (file_path)
			Result := {GTK}.gdk_pixbuf_new_from_file (path_str.item, $error_ptr)
			if is_attached (error_ptr) then
				create {CAIRO_GSTRING_IMP} error.share_from_pointer (g_error_message (error_ptr))
				Exception.raise_developer ("Error loading %S: %S", [file_path.base, error.string])
			end
		end

feature -- Measurement

	height (a_pixbuf: POINTER): INTEGER_32
		do
			Result := {GTK}.gdk_pixbuf_get_height (a_pixbuf)
		end

	width (a_pixbuf: POINTER): INTEGER_32
		do
			Result := {GTK}.gdk_pixbuf_get_width (a_pixbuf)
		end
end