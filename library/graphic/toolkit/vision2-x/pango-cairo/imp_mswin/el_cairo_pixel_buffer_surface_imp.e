note
	description: "Windows implementation of [$source EL_CAIRO_PIXMAP_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 16:19:58 GMT (Tuesday 28th July 2020)"
	revision: "3"

class
	EL_CAIRO_PIXEL_BUFFER_SURFACE_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			make as make_buffer,
			data as buffer_data
		undefine
			is_initialized
		redefine
			make_with_pixmap
		end

	EL_CAIRO_PIXEL_BUFFER_SURFACE_I undefine copy, default_create, width, height end

	EL_CAIRO_SURFACE_IMP undefine copy, default_create, width, height end

create
	make_with_pixmap

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			Precursor (a_pixmap)
			make_with_argb_32_data (data_ptr, width, height)
			unlock
		end

end
