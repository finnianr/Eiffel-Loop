note
	description: "Base class for drawable objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_DRAWING_AREA_BASE

inherit
	EV_DRAWING_AREA

	EL_DRAWABLE
		undefine
			default_create, copy
		end

feature -- Access

	resizeable_cell: EV_CELL
		do
			create Result
			Result.put (Current)
			delay_redraw_until_dimensions_set
		end

feature -- Element change

	set_expose_actions
		do
			expose_actions.extend (agent on_redraw)
		end

feature -- Basic operations

	delay_redraw_until_dimensions_set
		do
			expose_actions.block
			resize_actions.extend (agent on_resize)
		end

	simulate_pointer_motion
		local
			position: EV_COORDINATE
		do
			position := pointer_position
			pointer_motion_actions.call ([position.x, position.y, 0.0, 0.0, 0.0, screen_x + position.x, screen_y + position.y])
		end

feature {NONE} -- Event handlers

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if a_height > 1 and a_width > 1 then
				resize (a_width, a_height)
				expose_actions.resume
				redraw
			end
		end

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	resize (a_width, a_height: INTEGER)
			--
		do
			set_minimum_size (a_width, a_height)
		end

end
