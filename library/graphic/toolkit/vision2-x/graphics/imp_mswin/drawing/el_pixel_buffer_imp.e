note
	description: "Windows implementation of [$source EL_PIXEL_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 14:18:12 GMT (Saturday 1st August 2020)"
	revision: "2"

class
	EL_PIXEL_BUFFER_IMP

inherit
	EL_PIXEL_BUFFER_I

	WEL_GDIP_PIXEL_FORMAT
		export
			{NONE} all
		end

	EL_MODULE_GDI_BITMAP

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			set_is_initialized (True)
		end

	old_make (an_interface: EL_PIXEL_BUFFER)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature -- Conversion

	to_rgb_24_buffer: EV_PIXEL_BUFFER
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
			if attached {CAIRO_SURFACE_IMP} cairo.surface as surface then
				Result := surface.new_gdi_bitmap
			end
		end

end
