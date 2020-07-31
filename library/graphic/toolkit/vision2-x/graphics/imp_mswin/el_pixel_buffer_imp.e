note
	description: "Windows implementation of [$source EL_PIXEL_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 15:05:47 GMT (Friday 31st July 2020)"
	revision: "1"

class
	EL_PIXEL_BUFFER_IMP

inherit
	EL_PIXEL_BUFFER_I

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

feature {EV_ANY_HANDLER, EL_PIXMAP_I} -- Access

	to_gdi_bitmap: WEL_GDIP_BITMAP
		do
			if attached {CAIRO_SURFACE_IMP} cairo.surface as surface then
				Result := surface.new_gdi_bitmap
			end
		end

feature {NONE} -- Implementation

	destroy
			-- Destroy `Current'.
		do
			set_is_destroyed (True)
		end

end
