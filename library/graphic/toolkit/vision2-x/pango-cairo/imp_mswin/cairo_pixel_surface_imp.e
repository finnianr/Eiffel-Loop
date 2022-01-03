note
	description: "Windows implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "10"

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
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_drawing, make_with_size, make_with_buffer

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

	make_with_buffer (a_buffer: EV_PIXEL_BUFFER)
		-- make with Vision-2 pixel buffer
		do
			if attached {EV_PIXEL_BUFFER_IMP} a_buffer.implementation as imp_buffer then
				make_with_bitmap (Gdi_bitmap.new_clone (imp_buffer.gdip_bitmap, Format_premultiplied_ARGB_32))
			end
		end

	make_with_scaled_drawing (dimension: NATURAL_8; drawing: CAIRO_DRAWING_AREA; size: DOUBLE)
		local
			l_bitmap: WEL_GDIP_BITMAP
		do
			if attached {CAIRO_DRAWING_AREA_IMP} drawing.implementation as drawing_imp then
				l_bitmap := drawing_imp.to_gdi_bitmap
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
			make_with_bitmap (create {WEL_GDIP_BITMAP}.make_formatted (a_width, a_height, Format_premultiplied_ARGB_32))
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

	save_as_jpeg (file_path: FILE_PATH; quality: NATURAL)
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

feature {NONE} -- Internal attributes

	bitmap: WEL_GDIP_BITMAP

	image_data: WEL_GDIP_BITMAP_DATA

end