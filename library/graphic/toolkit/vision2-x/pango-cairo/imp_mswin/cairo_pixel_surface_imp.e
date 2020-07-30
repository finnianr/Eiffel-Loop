note
	description: "Windows implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:29:38 GMT (Thursday 30th July 2020)"
	revision: "4"

class
	CAIRO_PIXEL_SURFACE_IMP

inherit
	CAIRO_PIXEL_SURFACE_I

	CAIRO_SURFACE_IMP

	EV_ANY_HANDLER

	EL_MODULE_GDI_BITMAP

create
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_buffer

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_bitmap (Gdi_bitmap.new (a_pixmap))
		end

	make_with_scaled_buffer (dimension: NATURAL_8; buffer: EL_DRAWABLE_PIXEL_BUFFER; size: DOUBLE)
		local
			buffer_bitmap: WEL_GDIP_BITMAP
		do
			if attached {EL_DRAWABLE_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer then
				buffer_bitmap := imp_buffer.to_gdi_bitmap
				make_with_bitmap (Gdi_bitmap.new_scaled (dimension, buffer_bitmap, size.rounded))
				buffer_bitmap.destroy_item
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

	make_with_bitmap (a_bitmap: WEL_GDIP_BITMAP)
		do
			bitmap := a_bitmap
			image_data := Gdi_bitmap.new_data (a_bitmap, {WEL_GDIP_IMAGE_LOCK_MODE}.Read_only)
			make_with_argb_32_data (image_data.scan_0, a_bitmap.width, a_bitmap.height)
		end

feature {NONE} -- Implementation

	destroy
		do
			bitmap.unlock_bits (image_data)
			bitmap.destroy_item
		end

feature {NONE} -- Internal attributes

	image_data: WEL_GDIP_BITMAP_DATA

	bitmap: WEL_GDIP_BITMAP

end
