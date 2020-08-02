note
	description: "Windows implementation of [$source CAIRO_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 11:18:44 GMT (Sunday 2nd August 2020)"
	revision: "6"

class
	CAIRO_SURFACE_IMP

inherit
	CAIRO_SURFACE_I

	EL_OS_IMPLEMENTATION

	WEL_GDIP_PIXEL_FORMAT
		export
			{NONE} all
		end

	WEL_GDIP_IMAGE_LOCK_MODE
		rename
			is_valid as is_valid_lock_mode
		export
			{NONE} all
		end

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_file,
	make_from_pointer

feature -- Factory

	new_drawable: CAIRO_PANGO_CONTEXT_I
		do
			create {CAIRO_PANGO_CONTEXT_IMP} Result.make (Current)
		end

feature {EV_ANY_I} -- Implementation

	new_gdi_bitmap: WEL_GDIP_BITMAP
		-- copy of surface data
		local
			source_rect: WEL_GDIP_RECT; l_data: WEL_GDIP_BITMAP_DATA
			l_surface: CAIRO_SURFACE_I; l_context: CAIRO_PANGO_CONTEXT_I
		do
			-- Using premultiplied based on this info
			-- https://stackoverflow.com/questions/35521246/alpha-transparency-in-cairo
			create Result.make_formatted (width, height, Format32bppPARGB)
			create source_rect.make_with_size (0, 0, width, height)
			l_data := Result.lock_bits (source_rect, Write_only, Format32bppPArgb)

			create {CAIRO_SURFACE_IMP} l_surface.make_with_argb_32_data (l_data.scan_0, width, height)
			create {CAIRO_PANGO_CONTEXT_IMP} l_context.make (l_surface)
			l_context.draw_surface (0, 0, Current)
			Result.unlock_bits (l_data)
		end

end
