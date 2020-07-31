note
	description: "Windows implementation of [$source CAIRO_PIXEL_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 15:10:50 GMT (Friday 31st July 2020)"
	revision: "5"

class
	CAIRO_PIXEL_SURFACE_IMP

inherit
	CAIRO_PIXEL_SURFACE_I

	CAIRO_SURFACE_IMP

	EV_ANY_HANDLER

	EL_MODULE_GDI_BITMAP

	CAIRO_SHARED_GDK_API

create
	make_with_pixmap, make_with_scaled_pixmap, make_with_scaled_buffer, make_with_scaled_buf, make_with_size

feature {NONE} -- Initialization

	make_with_bitmap (a_bitmap: WEL_GDIP_BITMAP)
		do
			bitmap := a_bitmap
			image_data := Gdi_bitmap.new_data (a_bitmap, {WEL_GDIP_IMAGE_LOCK_MODE}.Read_only)
			is_locked := True
			make_with_argb_32_data (image_data.scan_0, a_bitmap.width, a_bitmap.height)
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_bitmap (Gdi_bitmap.new (a_pixmap))
		end

	make_with_scaled_buf (dimension: NATURAL_8; buffer: EL_PIXEL_BUFFER; size: DOUBLE)
		local
			l_bitmap: WEL_GDIP_BITMAP
		do
			if attached {EL_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer then
				l_bitmap := imp_buffer.to_gdi_bitmap
				make_with_bitmap (Gdi_bitmap.new_scaled (dimension, l_bitmap, size.rounded))
				l_bitmap.destroy_item
			end
		end

	make_with_scaled_buffer (dimension: NATURAL_8; buffer: EL_DRAWABLE_PIXEL_BUFFER; size: DOUBLE)
		local
			l_bitmap: WEL_GDIP_BITMAP
		do
			if attached {EL_DRAWABLE_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer then
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
