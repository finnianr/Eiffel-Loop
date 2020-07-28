note
	description: "Cairo pixmap source surface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:06:08 GMT (Monday 13th July 2020)"
	revision: "2"

deferred class
	EL_CAIRO_PIXMAP_SURFACE_I

inherit
	EL_CAIRO_SURFACE_I

feature {NONE} -- Initialization

	make (a_pixmap: EV_PIXMAP)
		deferred
		end

feature -- Basic operations

	destroy
		deferred
		end
end
