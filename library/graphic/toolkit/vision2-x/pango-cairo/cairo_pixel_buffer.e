note
	description: "GDK pixel buffer initialized from a file"
	notes: "[
		**Memory Leak **
		
		The GC dispose routine `Gobject.unref (this)' is not working in GTK2 version 2.12.10-5.
		Image data is not being released.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	CAIRO_PIXEL_BUFFER

inherit
	CAIRO_OWNED_G_OBJECT
		redefine
			c_free
		end

	EL_RECTANGULAR

	CAIRO_SHARED_GDK_PIXBUF_API

	CAIRO_SHARED_GDK_API

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

feature {NONE} -- Implementation

	c_free (this: POINTER)
		do
			if not is_in_final_collect then
--				Nothing works to free image memory !!! This is a widely reported bug.
--				Gdk.pixbuf_unref (this) -- (Deprecated function)
--				Gobject.clear ($this)

				Gobject.unref (this)
			end
		end

end