note
	description: "Unix implementation of [$source EL_CAIRO_PIXEL_BUFFER_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 18:54:04 GMT (Tuesday 28th July 2020)"
	revision: "4"

class
	EL_CAIRO_PIXEL_BUFFER_SURFACE_IMP

inherit
	EL_CAIRO_PIXEL_BUFFER_SURFACE_I
		undefine
			height, width, dispose, is_initialized
		end

	EL_CAIRO_SURFACE_IMP
		undefine
			height, width
		redefine
			dispose, is_initialized
		end

	EV_PIXEL_BUFFER_IMP
		rename
			make as make_buffer
		redefine
			make_with_pixmap, dispose, is_initialized
		end

	EL_SHARED_IMAGE_UTILS_API

create
	make_with_pixmap

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		local
			pixel_data: POINTER
		do
			Precursor (a_pixmap)
			pixel_data := data_ptr
			Image_utils.format_argb_to_abgr (pixel_data, width * height)

			self_ptr := Cairo.new_image_surface_for_data (pixel_data, Cairo.Format_RGB_24, width, height, stride)
		end

feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := Precursor {EV_PIXEL_BUFFER_IMP} and Precursor {EL_CAIRO_SURFACE_IMP}
		end

feature {NONE} -- Implementation

	stride: INTEGER
		do
			Result := {GTK}.gdk_pixbuf_get_rowstride (gdk_pixbuf).to_integer_32
		end

	dispose
		do
			Precursor {EL_CAIRO_PIXEL_BUFFER_SURFACE_I}
			Precursor {EV_PIXEL_BUFFER_IMP}
		end

end
