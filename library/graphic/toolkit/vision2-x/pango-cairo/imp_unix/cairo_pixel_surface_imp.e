note
	description: "Unix implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:29:38 GMT (Thursday 30th July 2020)"
	revision: "5"

class
	CAIRO_PIXEL_SURFACE_IMP

inherit
	CAIRO_PIXEL_SURFACE_I

	CAIRO_SURFACE_IMP

	EL_SHARED_IMAGE_UTILS_API

	EL_MODULE_GTK

create
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_buffer

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_gdk_buffer (GTK.new_gdk_pixel_buffer (a_pixmap), a_pixmap.width, a_pixmap.height)
		end

	make_with_scaled_buffer (dimension: NATURAL_8; buffer: EL_DRAWABLE_PIXEL_BUFFER; size: DOUBLE)
		do
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; a_pixmap: EV_PIXMAP; size: DOUBLE)
		local
			area: EL_RECTANGLE
		do
			create area.make_scaled_for_widget (dimension, a_pixmap, size.rounded)
			make_with_gdk_buffer (GTK.new_scaled_pixel_buffer (a_pixmap, area), area.width, area.height)
		end

	make_with_gdk_buffer (pixel_buffer: POINTER; a_width, a_height: INTEGER)
		local
			pixel_data: POINTER
		do
			gdk_pixel_buffer := pixel_buffer
			pixel_data := {GTK}.gdk_pixbuf_get_pixels (pixel_buffer)
			Image_utils.format_argb_to_abgr (pixel_data, a_width * a_height)

			make_with_argb_32_data (pixel_data, a_width, a_height)
		end

feature {NONE} -- Implementation

	destroy
		do
			{GTK2}.object_unref (gdk_pixel_buffer)
		end

feature {NONE} -- Internal attributes

	gdk_pixel_buffer: POINTER

end
