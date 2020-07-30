note
	description: "Unix implementation of [$source CAIRO_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:29:38 GMT (Thursday 30th July 2020)"
	revision: "3"

class
	CAIRO_SURFACE_IMP

inherit
	CAIRO_SURFACE_I

	EL_SHARED_IMAGE_UTILS_API

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_file

feature {NONE} -- Initialization

	make_with_buffer (buffer: EV_PIXEL_BUFFER)
		do
			if attached {EV_PIXEL_BUFFER_IMP} buffer.implementation as imp then
				make_with_argb_32_data (imp.data_ptr, buffer.width, buffer.height)
			end
		end

feature -- Status change

	set_surface_color_order
			-- swap red and blue color channels
		do
			flush
			Image_utils.format_argb_to_abgr (Cairo.surface_data (self_ptr), width * height)
			mark_dirty
		end

end
