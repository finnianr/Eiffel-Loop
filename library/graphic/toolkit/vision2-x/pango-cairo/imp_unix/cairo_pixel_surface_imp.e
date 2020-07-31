note
	description: "Unix implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 15:25:50 GMT (Friday 31st July 2020)"
	revision: "6"

class
	CAIRO_PIXEL_SURFACE_IMP

inherit
	CAIRO_PIXEL_SURFACE_I
		undefine
			c_free
		end

	CAIRO_SURFACE_IMP
		redefine
			c_free
		end

	EL_SHARED_IMAGE_UTILS_API

	EL_MODULE_GTK

create
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_buffer, make_with_size

feature {NONE} -- Initialization

	make_with_gdk_buffer (pixel_buffer: POINTER; a_width, a_height: INTEGER)
		local
			pixel_data: POINTER
		do
			gdk_pixel_buffer := pixel_buffer
			pixel_data := {GTK}.gdk_pixbuf_get_pixels (pixel_buffer)

			-- Swap blue and red
			Image_utils.format_argb_to_abgr (pixel_data, a_width * a_height)

			make_with_argb_32_data (pixel_data, a_width, a_height)
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_gdk_buffer (GTK.new_gdk_pixel_buffer (a_pixmap), a_pixmap.width, a_pixmap.height)
		end

	make_with_scaled_buf (dimension: NATURAL_8; buffer: EL_PIXEL_BUFFER; size: DOUBLE)
		do
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

	make_with_size (a_width, a_height: INTEGER)
		require else
			gtk_version_is_2_x: {GTK}.gtk_maj_ver >= 2
		local
			pixbuf: POINTER
		do
			pixbuf := {GTK}.gdk_pixbuf_new ({GTK}.gdk_colorspace_rgb_enum, True, 8, a_width, a_height)
			{GTK}.gdk_pixbuf_fill (pixbuf, 0)
			make_with_gdk_buffer (pixbuf, a_width, a_height)
		end

feature -- Basic operations

	destroy
		do
		end

feature -- Status change

	swap_blue_and_red
		do
			Image_utils.format_argb_to_abgr ({GTK}.gdk_pixbuf_get_pixels (gdk_pixel_buffer), width * height)
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
		do
			Precursor (this)
			if is_attached (gdk_pixel_buffer) then
				{GTK2}.object_unref (gdk_pixel_buffer)
			end
		end

feature {EV_PIXMAP_I} -- Internal attributes

	gdk_pixel_buffer: POINTER

end
