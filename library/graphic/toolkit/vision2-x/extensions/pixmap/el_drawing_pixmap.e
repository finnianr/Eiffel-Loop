note
	description: "Drawing pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:31:11 GMT (Friday 21st December 2018)"
	revision: "6"

deferred class
	EL_DRAWING_PIXMAP

inherit
	EL_PIXMAP
		redefine
			initialize, redraw
		end

	EL_DRAWABLE

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			resize_actions.extend (agent on_resize)
		end

feature -- Basic operations

	redraw
		do
			on_redraw (0, 0, width, height)
		end

feature {NONE} -- Event handlers

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if a_height > 1 and a_width > 1 then
				set_size (a_width, a_height)
				redraw
			end
		end

feature {NONE} -- Implementation

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
		deferred
		end
end
