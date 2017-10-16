note
	description: "Summary description for {EL_DRAWING_PIXMAP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_DRAWING_PIXMAP

inherit
	EL_PIXMAP
		redefine
			initialize, redraw
		end

	EL_DRAWABLE
		undefine
			is_equal, copy, default_create
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
end