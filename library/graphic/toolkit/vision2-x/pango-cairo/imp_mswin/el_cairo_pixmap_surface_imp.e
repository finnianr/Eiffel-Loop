note
	description: "Windows implementation of [$source EL_CAIRO_PIXMAP_SURFACE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:08:22 GMT (Monday 13th July 2020)"
	revision: "2"

class
	EL_CAIRO_PIXMAP_SURFACE_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			make as make_buffer,
			make_with_pixmap as make,
			data as buffer_data
		undefine
			is_initialized
		redefine
			make
		end

	EL_CAIRO_PIXMAP_SURFACE_I undefine copy, default_create, width, height end

	EL_CAIRO_SURFACE_IMP undefine copy, default_create, width, height end

create
	make

feature {NONE} -- Initialization

	make (a_pixmap: EV_PIXMAP)
		do
			Precursor (a_pixmap)
			make_with_argb_32_data (data_ptr, width, height)
			unlock
		end

end
