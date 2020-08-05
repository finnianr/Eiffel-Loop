note
	description: "Windows implementation of [$source CAIRO_DRAWING_AREA_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-04 8:56:44 GMT (Tuesday 4th August 2020)"
	revision: "4"

class
	CAIRO_DRAWING_AREA_IMP

inherit
	CAIRO_DRAWING_AREA_I
		rename
			remove_clip as reset_clip,
			set_angle as rotate
		end

	CAIRO_DRAWING_CONTEXT_IMP
		rename
			make as make_cairo_context
		end

	WEL_GDIP_PIXEL_FORMAT
		export
			{NONE} all
		end

	EL_MODULE_GDI_BITMAP

create
	make

feature -- Conversion

	to_buffer: EV_PIXEL_BUFFER
		-- Vision-2 pixel buffer
		local
			bitmap: like to_gdi_bitmap
		do
			create Result.make_with_size (1, 1)
			if attached {EV_PIXEL_BUFFER_IMP} Result.implementation as imp_result then
				bitmap := to_gdi_bitmap
				imp_result.set_gdip_image (Gdi_bitmap.new_clone (bitmap, Format32bppArgb))
				bitmap.destroy_item
			end
		end

feature {EV_ANY_HANDLER, EL_PIXMAP_I} -- Access

	to_gdi_bitmap: WEL_GDIP_BITMAP
		do
			if attached {CAIRO_SURFACE_IMP} surface as l_surface then
				Result := l_surface.new_gdi_bitmap
			end
		end

end
