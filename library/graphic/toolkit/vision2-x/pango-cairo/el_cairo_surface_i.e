note
	description: "Cairo drawing or source surface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-12 16:41:43 GMT (Sunday 12th July 2020)"
	revision: "1"

deferred class
	EL_CAIRO_SURFACE_I

inherit
	EL_DISPOSEABLE

	EL_SHARED_CAIRO_API

	EL_CAIRO_CONSTANTS

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		deferred
		end

feature -- Access

	item: POINTER

feature {NONE} -- Implementation

	dispose
		do
			Cairo.destroy_surface (item)
		end
end
