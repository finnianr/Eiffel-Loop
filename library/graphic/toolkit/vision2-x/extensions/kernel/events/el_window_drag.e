note
	description: "Allows any ${EV_WIDGET} to be used as handle to drag a window to a new position"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-05 19:06:44 GMT (Wednesday 5th July 2023)"
	revision: "13"

class
	EL_WINDOW_DRAG

inherit
	ANY

	EL_MODULE_ACTION; EL_MODULE_SCREEN

	EL_SHARED_DEFAULT_PIXMAPS

create
	make

feature {NONE} -- Initialization

	make (a_window: EV_WINDOW; a_title_bar: EV_WIDGET)
		do
			window := a_window; title_bar := a_title_bar

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
				old_x := window.screen_x; old_y := window.screen_y
				anchor_x := a_screen_x; anchor_y := a_screen_y
				anchor_y := title_bar.screen_y + title_bar.height // 5
				Screen.set_pointer_position (anchor_x, anchor_y)

				title_bar.set_pointer_style (Pixmaps.Hyperlink_cursor)
			end
		end

	on_pointer_button_release (
		x_pos, y_pos, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER
	)
		do
			if button = 1 and is_active  then
				is_active := False
				title_bar.set_pointer_style (Pixmaps.Standard_cursor)
			end
		end

	on_pointer_leave
		local
			i: INTEGER
		do
			if is_active then
				from i := 1 until i > 3 loop
					Action.do_later (i * 100, agent move_window_to_pointer)
					i := i + 1
				end
			end
		end

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if is_active then
				window.set_position (old_x + (a_screen_x - anchor_x), old_y + (a_screen_y - anchor_y))
			end
		end

feature {NONE} -- Implementation

	move_window_to_pointer
		do
			if attached Screen.pointer_position as p then
				on_pointer_motion (0, 0, 0, 0, 0, p.x, p.y)
			end
		end

feature {NONE} -- Internal attributes

	anchor_x: INTEGER

	anchor_y: INTEGER

	old_x: INTEGER

	old_y: INTEGER

	title_bar: EV_WIDGET

	window: EV_WINDOW

end