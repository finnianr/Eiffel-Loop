note
	description: "Unix implementation of [$source EL_PANGO_CAIRO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-07 14:21:24 GMT (Tuesday 7th July 2020)"
	revision: "1"

class
	EL_PANGO_CAIRO_CONTEXT_IMP

inherit
	EL_PANGO_CAIRO_CONTEXT_I

	EL_SHARED_IMAGE_UTILS_API

create
	make_argb_32, make_rgb_24, make_with_argb_32_data, make_with_rgb_24_data, make_from_file, make_with_surface

feature {NONE} -- Implementation

	check_font_availability
		do
		end

	set_source_color
		do
			Cairo.set_source_rgba (self_ptr, color.red, color.green, color.blue, 1.0)
		end

	set_surface_color_order
			-- swap red and blue color channels
		do
			Cairo.surface_flush (surface)
			Image_utils.format_argb_to_abgr (Cairo.surface_data (surface), width * height)
			Cairo.surface_mark_dirty (surface)
		end
end
