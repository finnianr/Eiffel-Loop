note
	description: "Unix implementation of [$source EL_PIXEL_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 15:23:12 GMT (Friday 31st July 2020)"
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

feature {EL_PIXMAP_I} -- Conversion

	to_pixel_surface: CAIRO_PIXEL_SURFACE_IMP
		do
			create Result.make_with_size (width, height)
			new_cairo (Result).draw_surface (0, 0, cairo.surface)
		end

feature {NONE} -- Implementation

	destroy
			-- Destroy `Current'.
		do
			set_is_destroyed (True)
		end

end
