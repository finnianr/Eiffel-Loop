note
	description: "Windows implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 14:13:15 GMT (Saturday 1st August 2020)"
	revision: "6"

class
	CAIRO_PIXEL_SURFACE_IMP

inherit
	CAIRO_PIXEL_SURFACE_I
		rename
			adjust_colors as do_nothing
		end

	CAIRO_SURFACE_IMP

	EV_ANY_HANDLER

	EL_MODULE_GDI_BITMAP

	WEL_GDIP_IMAGE_ENCODER_CONSTANTS
		export
			{NONE} all
		end

create
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_buffer, make_with_size, make_with_rgb_24

feature {NONE} -- Initialization

	make_with_bitmap (a_bitmap: WEL_GDIP_BITMAP)
		do
			bitmap := a_bitmap
			image_data := Gdi_bitmap.new_data (a_bitmap, {WEL_GDIP_IMAGE_LOCK_MODE}.Read_only)
			make_with_argb_32_data (image_data.scan_0, a_bitmap.width, a_bitmap.height)
			is_locked := True
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_bitmap (Gdi_bitmap.new (a_pixmap))
		end

	make_with_rgb_24 (a_buffer: EV_PIXEL_BUFFER)
		do
			if attached {EV_PIXEL_BUFFER_IMP} a_buffer.implementation as imp_buffer then
				make_with_bitmap (Gdi_bitmap.new_clone (imp_buffer.gdip_bitmap, Format32bppPArgb))
			end
		end

	make_with_scaled_buffer (dimension: NATURAL_8; buffer: EL_PIXEL_BUFFER; size: DOUBLE)
		local
			l_bitmap: WEL_GDIP_BITMAP
		do
			if attached {EL_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer then
				l_bitmap := imp_buffer.to_gdi_bitmap
				make_with_bitmap (Gdi_bitmap.new_scaled (dimension, l_bitmap, size.rounded))
				l_bitmap.destroy_item
			end
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; a_pixmap: EV_PIXMAP; size: DOUBLE)
		local
			l_bitmap: WEL_GDIP_BITMAP
		do
			l_bitmap := Gdi_bitmap.new (a_pixmap)
			make_with_bitmap (Gdi_bitmap.new_scaled (dimension, l_bitmap, size.rounded))
			l_bitmap.destroy_item
		end

	make_with_size (a_width, a_height: INTEGER)
		do
			make_with_bitmap (create {WEL_GDIP_BITMAP}.make_formatted (a_width, a_height, Format32bppPArgb))
		end

feature -- Status query

	is_locked: BOOLEAN
		-- `True' if `image_data' is locked

feature -- Basic operations

	destroy
		do
			if is_locked then
				unlock
			end
			bitmap.destroy_item
		end

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		local
			list: WEL_GDIP_IMAGE_ENCODER_PARAMETERS
			quality_parameter: WEL_GDIP_IMAGE_ENCODER_PARAMETER
		do
			create quality_parameter.make (Jpeg.Quality, quality)
			create list.make (1)
			list.parameters.extend (quality_parameter)
			bitmap.save_image_to_path_with_encoder_and_parameters (file_path, Jpeg, list)
		end

	unlock
		require
			locked: is_locked
		do
			bitmap.unlock_bits (image_data)
		end

feature {EV_PIXMAP_I, EL_PIXEL_BUFFER_I} -- Internal attributes

	bitmap: WEL_GDIP_BITMAP

	image_data: WEL_GDIP_BITMAP_DATA

end
