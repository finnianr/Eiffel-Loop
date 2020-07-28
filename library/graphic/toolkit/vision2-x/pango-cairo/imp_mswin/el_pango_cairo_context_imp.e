note
	description: "Windows implementation of [$source EL_PANGO_CAIRO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 18:23:10 GMT (Tuesday 28th July 2020)"
	revision: "4"

class
	EL_PANGO_CAIRO_CONTEXT_IMP

inherit
	EL_PANGO_CAIRO_CONTEXT_I
		redefine
			draw_scaled_pixel_buffer, draw_scaled_pixmap
		end

	EL_MODULE_SYSTEM_FONTS

	WEL_GDIP_PIXEL_FORMAT
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Implementation

	check_font_availability
		local
			substitute_fonts: like System_fonts.Substitute_fonts
		do
			substitute_fonts := System_fonts.Substitute_fonts
			substitute_fonts.search (font.name)
			if substitute_fonts.found then
				font.preferred_families.start
				font.preferred_families.replace (substitute_fonts.found_item.to_string_32)
			end
		end

	draw_scaled_pixel_buffer (dimension: NATURAL_8; x, y, size: DOUBLE; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		--
		local
			src_bitmap, scaled_bitmap: WEL_GDIP_BITMAP
			graphics: WEL_GDIP_GRAPHICS; dest_rect, scaled_rect: WEL_RECT; area: EL_RECTANGLE
		do
			if buffer.is_argb_32_format then
				create area.make_scaled_for_pixels (dimension, buffer, size.rounded)
				create scaled_bitmap.make_with_size (area.width, area.height)

				if attached {EL_DRAWABLE_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer
					and then attached {EL_CAIRO_SURFACE_IMP} imp_buffer.cairo_context.surface as src_surface
				then
					src_bitmap := src_surface.new_gdi_bitmap
					create scaled_rect.make (0, 0, buffer.width, buffer.height)
					create dest_rect.make (0, 0, area.width, area.height)

					create graphics.make_from_image (scaled_bitmap)
					graphics.draw_image_with_dest_rect_src_rect (src_bitmap, dest_rect, scaled_rect)
					dest_rect.dispose; scaled_rect.dispose
					graphics.destroy_item

					draw_bitmap (x, y, scaled_bitmap)
					scaled_bitmap.destroy_item; src_bitmap.destroy_item
				else
					Precursor (dimension, x, y, size, buffer)
				end
			end
		end

	draw_bitmap (x, y: DOUBLE; bitmap: WEL_GDIP_BITMAP)
		local
			l_rect: WEL_GDIP_RECT; image_data: WEL_GDIP_BITMAP_DATA
		do
			create l_rect.make_with_size (0, 0, bitmap.width, bitmap.height)
			image_data := bitmap.lock_bits (l_rect, {WEL_GDIP_IMAGE_LOCK_MODE}.Read_only, Format32bppPArgb)
			draw_surface (
				x, y, create {EL_CAIRO_SURFACE_IMP}.make_with_argb_32_data (image_data.scan_0, l_rect.width, l_rect.height)
			)
			bitmap.unlock_bits (image_data)
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EL_PIXMAP)
		local
			scaled: EL_PIXMAP
		do
			create scaled.make_scaled_to_size (dimension, a_pixmap, a_size.rounded)
			draw_pixmap (x, y, scaled)
		end

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end
