note
	description: "Cairo pixel buffer source surface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 16:19:45 GMT (Tuesday 28th July 2020)"
	revision: "3"

deferred class
	EL_CAIRO_PIXEL_BUFFER_SURFACE_I

inherit
	EL_CAIRO_SURFACE_I

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		deferred
		end

feature -- Basic operations

	destroy
		deferred
		end
end
