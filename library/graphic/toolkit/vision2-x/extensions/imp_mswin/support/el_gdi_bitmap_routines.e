note
	description: "GDI+ bitmap routines accessible via [$source EL_MODULE_GDI_BITMAP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_GDI_BITMAP_ROUTINES

inherit
	WEL_GDIP_IMAGE_LOCK_MODE
		rename
			is_valid as is_valid_lock_mode
		export
			{NONE} all
			{ANY} is_valid_lock_mode
		end

	WEL_GDIP_PIXEL_FORMAT
		export
			{NONE} all
		end

	EV_ANY_HANDLER

feature -- Factory

	new (a_pixmap: EV_PIXMAP): WEL_GDIP_BITMAP
		do
			if attached {EV_PIXMAP_IMP_STATE} a_pixmap.implementation as imp_pixmap then
				create Result.make_from_bitmap (imp_pixmap.get_bitmap, imp_pixmap.palette)
			else
				create Result.make_formatted (a_pixmap.width, a_pixmap.width, Format32bppPArgb)
			end
		end

	new_clone (bitmap: WEL_GDIP_BITMAP; format: INTEGER): WEL_GDIP_BITMAP
		local
			rect: WEL_GDIP_RECT
		do
			create rect.make_with_size (0, 0, bitmap.width, bitmap.height)
			Result := bitmap.clone_rectangle_pixel_format (rect, format)
		end

	new_data (bitmap: WEL_GDIP_BITMAP; lock_bitmode_flag: NATURAL_32): WEL_GDIP_BITMAP_DATA
		-- premultiplied image data in ARGB format
		require
			valid_lock_mode: is_valid_lock_mode (lock_bitmode_flag)
		local
			rect: WEL_GDIP_RECT
		do
			create rect.make_with_size (0, 0, bitmap.width, bitmap.height)
			Result := bitmap.lock_bits (rect, lock_bitmode_flag, Format32bppPArgb)
		end

	new_scaled (dimension: NATURAL_8; bitmap: WEL_GDIP_BITMAP; size: INTEGER): WEL_GDIP_BITMAP
		local
			graphics: WEL_GDIP_GRAPHICS; dest_rect, source_rect: WEL_RECT
			proportion: DOUBLE
		do
			if dimension = {EL_DIRECTION}.By_width then
				proportion := size / bitmap.width
			else
				proportion := size / bitmap.height
			end
			create dest_rect.make (0, 0, (bitmap.width * proportion).rounded, (bitmap.height * proportion).rounded)
			create source_rect.make (0, 0, bitmap.width, bitmap.height)

			create Result.make_with_size (dest_rect.width, dest_rect.height)
			create graphics.make_from_image (Result)
			graphics.draw_image_with_dest_rect_src_rect (bitmap, dest_rect, source_rect)

			dest_rect.dispose; source_rect.dispose
			graphics.destroy_item
		end

end