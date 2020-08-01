note
	description: "Unix implementation of [$source EL_PIXEL_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 13:45:05 GMT (Saturday 1st August 2020)"
	revision: "2"

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

feature -- Conversion

	to_rgb_24_buffer: EV_PIXEL_BUFFER
		local
			surface: CAIRO_PIXEL_SURFACE_I
		do
			create Result.make_with_size (width, height)
			create {CAIRO_PIXEL_SURFACE_IMP} surface.make_with_rgb_24 (Result)
			new_cairo (surface).draw_surface (0, 0, cairo.surface)
			surface.adjust_colors
			surface.destroy
		end

feature {NONE} -- Implementation

	destroy
			-- Destroy `Current'.
		do
			set_is_destroyed (True)
		end

end
