note
	description: "Windows implementation of [$source EL_CAIRO_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:00:56 GMT (Monday 13th July 2020)"
	revision: "2"

class
	EL_CAIRO_SURFACE_IMP

inherit
	EL_CAIRO_SURFACE_I

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_file,
	make_from_pointer, make_with_buffer

feature {NONE} -- Initialization

	make_with_buffer (buffer: EV_PIXEL_BUFFER)
		do
			if attached {EV_PIXEL_BUFFER_IMP} buffer.implementation as imp then
				make_with_argb_32_data (imp.data_ptr, buffer.width, buffer.height)
				imp.unlock
			end
		end

feature -- Status change

	set_surface_color_order
			-- swap red and blue color channels
		do
		end

end
