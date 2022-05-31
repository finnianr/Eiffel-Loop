note
	description: "GDK pixel buffer initialized from a file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 16:50:22 GMT (Tuesday 31st May 2022)"
	revision: "1"

class
	CAIRO_PIXEL_BUFFER

inherit
	EL_OWNED_C_OBJECT
		export
			{CAIRO_SHARED_API, CAIRO_DRAWING_AREA_I} self_ptr
		end

	EL_RECTANGULAR

	CAIRO_SHARED_GDK_PIXBUF

	CAIRO_SHARED_GOBJECT_API

create
	make

feature {NONE} -- Initialization

	make (image_path: FILE_PATH)
		do
			make_from_pointer (Gdk_pixbuf.new_from_file (image_path))
		end

feature -- Measurement

	height: INTEGER
		do
			Result := Gdk_pixbuf.height (self_ptr)
		end

	width: INTEGER
		do
			Result := Gdk_pixbuf.width (self_ptr)
		end

feature {CAIRO_DRAWABLE_CONTEXT_I} -- Implementation

	c_free (this: POINTER)
		do
			Gobject.object_unref (this)
		end

end