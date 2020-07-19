note
	description: "Base class for drawable objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-18 12:17:07 GMT (Saturday 18th July 2020)"
	revision: "7"

deferred class
	EL_DRAWING_AREA_BASE

inherit
	EV_DRAWING_AREA
		undefine
			draw_text, draw_text_top_left, draw_ellipsed_text, draw_ellipsed_text_top_left
		redefine
			implementation
		end

	EL_DRAWABLE
		undefine
			is_in_default_state
		redefine
			implementation
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
			pointer_motion_actions.call (
				[position.x, position.y, 0.0, 0.0, 0.0, screen_x + position.x, screen_y + position.y]
			)
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

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Implementation

	implementation: EV_DRAWING_AREA_I

end
