note
	description: "Window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-11 7:21:45 GMT (Tuesday 11th August 2020)"
	revision: "7"

deferred class
	EL_POSITIONABLE

inherit
	EL_MODULE_SCREEN

feature -- Measurement

	center_point: EV_COORDINATE
			-- Center point of window
		do
			if attached implementation as imp then
				create Result.make (imp.screen_x + imp.width // 2, imp.screen_y + imp.height // 2)
			else
				create Result
			end
		end

feature -- Status setting

	set_position (a_x, a_y: INTEGER)
		do
			implementation.set_position (a_x.max (Screen.useable_area.x), a_y.max (Screen.useable_area.y))
		end

	set_x_position (a_x: INTEGER)
		do
			implementation.set_x_position (a_x.max (Screen.useable_area.x))
		end

	set_y_position (a_y: INTEGER)
		do
			implementation.set_y_position ((a_y.max (Screen.useable_area.y)))
		end

feature -- Basic operations

	center_horizontally
		local
			width: INTEGER
		do
			width := implementation.width
			set_x_position (Screen.useable_area.x + (Screen.useable_area.width - width) // 2)
		end

	center_vertically
		local
			height: INTEGER
		do
			height := implementation.height
			set_y_position (Screen.useable_area.y + (Screen.useable_area.height - height) // 2)
		end

	center_window
		do
			center_horizontally; center_vertically
		end

	position_window_center (window: EV_POSITIONABLE)
			-- center window in current but do not let it exceed the top
		local
			coord: EV_COORDINATE; screen_y: INTEGER
		do
			coord := center_point
			screen_y := implementation.screen_y
			window.set_position (coord.x - window.width // 2, (coord.y - window.height // 2).max (screen_y))
		end

feature {NONE} -- Implementation

	implementation: EV_POSITIONABLE_I
		deferred
		end

end
