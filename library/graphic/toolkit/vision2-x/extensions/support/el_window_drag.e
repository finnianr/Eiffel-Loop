note
	description: "Window drag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-20 13:43:14 GMT (Monday 20th May 2019)"
	revision: "5"

class
	EL_WINDOW_DRAG

inherit
	ANY
	
	EL_MODULE_SCREEN

	EL_MODULE_GUI

	EL_MODULE_PIXMAP

create
	make

feature {NONE} -- Initialization

	make (a_window: EV_WINDOW; a_title_bar: EV_WIDGET)
		do
			window := a_window; title_bar := a_title_bar
			create old_position
			create anchor_position

			title_bar.pointer_button_press_actions.extend (agent on_pointer_button_press)

			title_bar.pointer_motion_actions.extend (agent on_pointer_motion)
			title_bar.pointer_button_release_actions.extend (agent on_pointer_button_release)
			title_bar.pointer_leave_actions.extend (agent on_pointer_leave)
		end

feature -- Status query

	is_active: BOOLEAN

feature -- Event handling

	on_pointer_button_press (
		x_pos, y_pos, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER
	)
		do
			if button = 1 and not is_active then
				is_active := True
				old_position.set_position (window.screen_x, window.screen_y)
				anchor_position.set_position (a_screen_x, a_screen_y)
				anchor_position.set_y (title_bar.screen_y + title_bar.height // 5)
				GUI.Screen.set_pointer_position (anchor_position.x, anchor_position.y)

				title_bar.set_pointer_style (Pixmap.Hyperlink_cursor)
			end
		end

	on_pointer_button_release (
		x_pos, y_pos, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER
	)
		do
			if button = 1 and is_active  then
				is_active := False
				title_bar.set_pointer_style (Pixmap.Standard_cursor)
			end
		end

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if is_active then
				window.set_position (
					old_position.x + (a_screen_x - anchor_position.x), old_position.y + (a_screen_y - anchor_position.y)
				)
			end
		end

	on_pointer_leave
		local
			i: INTEGER
		do
			if is_active then
				from i := 1 until i > 3 loop
					GUI.do_later (agent move_window_to_pointer, i * 100)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	move_window_to_pointer
		local
			position: EV_COORDINATE
		do
			position := GUI.Screen.pointer_position
			on_pointer_motion (0, 0, 0, 0, 0, position.x, position.y)
		end

feature {NONE} -- Internal attributes

	window: EV_WINDOW

	title_bar: EV_WIDGET

	old_position: EV_COORDINATE

	anchor_position: EV_COORDINATE
		-- Pointer anchor

end
