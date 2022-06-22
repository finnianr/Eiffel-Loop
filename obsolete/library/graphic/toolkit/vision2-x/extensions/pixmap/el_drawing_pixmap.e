note
	description: "Drawing pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 12:25:56 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_DRAWING_PIXMAP

inherit
	EL_PIXMAP
		redefine
			initialize, implementation, redraw
		end

	EL_DRAWABLE
		undefine
			copy, is_equal, is_in_default_state, initialize, sub_pixmap
		redefine
			implementation
		end

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

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Implementation

	implementation: EV_PIXMAP_I
end
