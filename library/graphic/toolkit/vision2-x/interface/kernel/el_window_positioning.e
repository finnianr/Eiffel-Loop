note
	description: "Summary description for {EL_WINDOW_POSITIONING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-03 12:14:46 GMT (Monday 3rd June 2013)"
	revision: "2"

deferred class
	EL_WINDOW_POSITIONING

inherit
	EL_MODULE_SCREEN

feature -- Measurement

	center_position: EV_COORDINATE
			--
		do
			create Result.make (screen_x + width // 2, screen_y + height // 2)
		end

	screen_x: INTEGER
			-- Horizontal offset relative to screen.
		deferred
		end

	screen_y: INTEGER
			-- Vertical offset relative to screen.
		deferred
		end

	width: INTEGER
			-- Horizontal size in pixels.
			-- Same as `minimum_width' when not displayed.
		deferred
		end

	height: INTEGER
			-- Vertical size in pixels.
			-- Same as `minimum_height' when not displayed.
		deferred
		end

feature -- Status setting

	set_x_position (a_x: INTEGER)
			-- Assign `a_x' to `x_position' in pixels.
		deferred
		end

	set_y_position (a_y: INTEGER)
			-- Assign `a_y' to `y_position' in pixels.
		deferred
		end

	set_position (a_x, a_y: INTEGER)
			-- Assign `a_x' to `x_position' and `a_y' to `y_position' in pixels.
		deferred
		end

feature -- Basic operations

	position_window_center (window: EV_POSITIONABLE)
			-- center window in current but do not let it exceed the top
		local
			coord: EV_COORDINATE
		do
			coord := center_position
			window.set_position (coord.x - window.width // 2, (coord.y - window.height // 2).max (screen_y))
		end

	center_window
		do
			center_horizontally; center_vertically
		end

	center_horizontally
		do
			set_x_position ((Screen.width - width) // 2)
		end

	center_vertically
		do
			set_y_position ((Screen.height - height) // 2)
		end

end
