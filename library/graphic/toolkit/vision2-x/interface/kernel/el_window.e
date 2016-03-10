note
	description: "Summary description for {EL_WINDOW_POSITIONING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-02 10:32:14 GMT (Friday 2nd January 2015)"
	revision: "5"

deferred class
	EL_WINDOW

inherit
	EL_MODULE_SCREEN

feature -- Measurement

	center_point: EV_COORDINATE
			-- Center point of window
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

	set_absolute_position (a_x, a_y: INTEGER)
			-- set position without taking account of useable area
		deferred
		end

	set_absolute_x_position (a_x: INTEGER)
		deferred
		end

	set_absolute_y_position (a_y: INTEGER)
		deferred
		end

	set_position (a_x, a_y: INTEGER)
		do
			set_absolute_position (a_x.max (Screen.useable_area.x), a_y.max (Screen.useable_area.y))
		end

	set_x_position (a_x: INTEGER)
		do
			set_absolute_x_position (a_x.max (Screen.useable_area.x))
		end

	set_y_position (a_y: INTEGER)
		do
			set_absolute_y_position (a_y.max (Screen.useable_area.y))
		end

feature -- Basic operations

	position_window_center (window: EV_POSITIONABLE)
			-- center window in current but do not let it exceed the top
		local
			coord: EV_COORDINATE
		do
			coord := center_point
			window.set_position (coord.x - window.width // 2, (coord.y - window.height // 2).max (screen_y))
		end

	center_window
		do
			center_horizontally; center_vertically
		end

	center_horizontally
		do
			set_x_position (Screen.useable_area.x + (Screen.useable_area.width - width) // 2)
		end

	center_vertically
		do
			set_y_position (Screen.useable_area.y + (Screen.useable_area.height - height) // 2)
		end

end
