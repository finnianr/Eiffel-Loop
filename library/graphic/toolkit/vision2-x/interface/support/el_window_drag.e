note
	description: "Summary description for {EL_WINDOW_DRAG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-16 11:53:34 GMT (Thursday 16th May 2013)"
	revision: "2"

class
	EL_WINDOW_DRAG

inherit
	EL_MODULE_SCREEN

	EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make (a_window: EV_WINDOW; a_title_bar: EV_WIDGET; a_grab_hand_pixmap: EV_PIXMAP)
		do
			window := a_window; title_bar := a_title_bar
			create grab_hand_style.make_with_pixmap (a_grab_hand_pixmap,
				a_grab_hand_pixmap.width // 2, a_grab_hand_pixmap.width // 2
			)
			create old_position
			create anchor_position

			title_bar.pointer_motion_actions.extend (agent on_pointer_motion)
			title_bar.pointer_button_press_actions.extend (agent on_pointer_button_press)
			title_bar.pointer_button_release_actions.extend (agent on_pointer_button_release)
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
				window.set_pointer_style (Grab_hand_style)
			end
		end

	on_pointer_button_release (
		x_pos, y_pos, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER
	)
		do
			if button = 1 and is_active  then
				is_active := False
				window.set_pointer_style (GUI.Standard_cursor)
			end
		end

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if is_active then
				-- Perhaps it's ok to let it be the standard cursor otherwise you get flicker
--				if {PLATFORM}.is_windows then
--					window.set_pointer_style (Grab_hand_style) -- workaround for bug in Windows implemenation
--				end
				window.set_position (
					old_position.x + (a_screen_x - anchor_position.x), old_position.y + (a_screen_y - anchor_position.y)
				)
			end
		end

feature {NONE} -- Implementation

	window: EV_WINDOW

	title_bar: EV_WIDGET

	old_position: EV_COORDINATE

	anchor_position: EV_COORDINATE
		-- Pointer anchor

	grab_hand_style: EV_POINTER_STYLE

end
