note
	description: "Unix implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 12:44:25 GMT (Saturday 1st August 2020)"
	revision: "7"

class
	CAIRO_PIXEL_SURFACE_IMP

inherit
	CAIRO_PIXEL_SURFACE_I
		rename
			adjust_colors as swap_blue_and_red
		undefine
			c_free
		end

	CAIRO_SURFACE_IMP
		redefine
			c_free
		end

	EL_SHARED_IMAGE_UTILS_API

	EL_MODULE_GTK

	EL_SHARED_IMAGE_ACCESS

create
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_buffer, make_with_size, make_with_rgb_24

feature {NONE} -- Initialization

	make_with_gdk_buffer (pixel_buffer: POINTER; a_width, a_height: INTEGER)
		do
			gdk_pixel_buffer := pixel_buffer
			pixel_data := {GTK}.gdk_pixbuf_get_pixels (pixel_buffer)

			Image_utils.format_argb_to_abgr (pixel_data, a_width * a_height)

			make_with_argb_32_data (pixel_data, a_width, a_height)
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_gdk_buffer (GTK.new_gdk_pixel_buffer (a_pixmap), a_pixmap.width, a_pixmap.height)
		end

	make_with_scaled_buffer (dimension: NATURAL_8; buffer: EL_PIXEL_BUFFER; size: DOUBLE)
		do
		end

	make_with_rgb_24 (a_buffer: EV_PIXEL_BUFFER)
		do
			if attached {EV_PIXEL_BUFFER_IMP} a_buffer.implementation as imp_buffer then
				pixel_data := imp_buffer.data_ptr
				Image_utils.format_argb_to_abgr (pixel_data, imp_buffer.width * imp_buffer.height)
				make_with_rgb_24_data (pixel_data, imp_buffer.width, imp_buffer.height)
			end
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

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		require else
			valid_gtk_version: {GTK}.gtk_maj_ver >= 2
		local
			handle, type: EV_GTK_C_STRING
			gerror: POINTER; quality_parameter: EV_GTK_C_STRING
		do
			if is_attached (gdk_pixel_buffer) then
				quality_parameter := quality.out; type := Type_jpeg
				create handle.make_from_path (file_path)
				{EL_GTK2}.gdk_pixbuf_save_jpeg (gdk_pixel_buffer, handle.item, type.item, quality_parameter.item, $gerror)
				if gerror /= default_pointer then
					on_fail (file_path.base)
				end
			else
				on_fail (file_path.base)
			end
		end

feature -- Status change

	swap_blue_and_red
		do
			Image_utils.format_argb_to_abgr (pixel_data, width * height)
		end

feature {NONE} -- Event handling

	on_fail (base: ZSTRING)
		do
			Exception.raise_developer ("Could not save file %"%S%" as jpeg", [base])
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
		do
			Precursor (this)
			if is_attached (gdk_pixel_buffer) then
				{GTK2}.object_unref (gdk_pixel_buffer)
				gdk_pixel_buffer := default_pointer
			end
		end

feature {EV_PIXMAP_I, EL_JPEG_IMAGE_I} -- Internal attributes

	pixel_data: POINTER

	gdk_pixel_buffer: POINTER

feature {NONE} -- Constants

	Type_jpeg: STRING = "jpeg"

end
