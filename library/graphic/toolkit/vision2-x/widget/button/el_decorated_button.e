note
	description: "[
		Button decorated by a set of 3 images, one for each of the states:
			1. Normal
			2. Mouse hover
			3. Clicked (Depressed)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_DECORATED_BUTTON

inherit
	EV_BUTTON
		redefine
			initialize, set_background_color, enable_sensitive, disable_sensitive, is_sensitive
		end

	EL_MODULE_GUI
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

	EV_BUILDER

create
	default_create, make, make_with_action

feature {NONE} -- Initialization

	initialize
		do
			is_sensitive := True
			pixmap_set := Default_pixmap_set
			Precursor
		end

	make (a_pixmap_set: like pixmap_set)
			--
		do
			default_create
			pointer_enter_actions.extend (agent on_pointer_enter)
			pointer_leave_actions.extend (agent on_pointer_leave)
			pointer_motion_actions.extend (agent on_pointer_motion)
			pointer_button_press_actions.extend (agent on_pointer_button_press)
			pointer_button_release_actions.extend (agent on_pointer_button_release)

			pixmap_set := a_pixmap_set
			set_pixmap (pixmap_set.normal)
			set_minimum_size (pixmap_set.normal.width, pixmap_set.normal.height)
			focus_out_actions.extend (agent set_pixmap_normal)
		end

	make_with_action (a_pixmap_set: EL_SVG_BUTTON_PIXMAP_SET; a_action: PROCEDURE)
			--
		do
			make (a_pixmap_set)
			select_actions.extend (a_action)
		end

feature -- Status report

	is_cursor_over: BOOLEAN

	is_sensitive: BOOLEAN

feature -- Status setting

	enable_sensitive
			-- Make object sensitive to user input.
		do
			pixmap_set.set_enabled
			is_sensitive := True
			select_actions.resume
			on_pointer_leave
		end

	disable_sensitive
			-- Make object non-sensitive to user input.
		do
			pixmap_set.set_disabled
			is_sensitive := False
			select_actions.block
			on_pointer_leave
		end

feature -- Element change

	set_pixmap_set (a_pixmap_set: like pixmap_set)
		do
			if not is_sensitive then
				a_pixmap_set.set_disabled
			end
			pixmap_set := a_pixmap_set
			if is_sensitive then
				if is_cursor_over then
					set_pixmap_highlighted
				else
					set_pixmap_normal
				end
			else
				set_pixmap_normal
			end
		end

	set_background_color (a_color: like background_color)
		do
			Precursor (a_color)
			pixmap_set.set_background_color (a_color)
			if is_cursor_over then
				set_pixmap_highlighted
			else
				set_pixmap_normal
			end
		end

	set_pixmap_normal
		do
			set_pixmap (pixmap_set.normal)
		end

	set_pixmap_depressed
		do
			set_pixmap (pixmap_set.depressed)
		end

	set_pixmap_highlighted
		do
			set_pixmap (pixmap_set.highlighted)
		end

feature {NONE} -- Event handlers

	on_pointer_enter
			--
		do
			if is_sensitive then
				set_pointer_style (GUI.Hyperlink_cursor)
				is_cursor_over := True
				set_pixmap_highlighted
			end
		end

	on_pointer_leave
			--
		do
			set_pointer_style (GUI.Standard_cursor)
			is_cursor_over := False
			set_pixmap_normal
		end

	on_pointer_motion (a_x, a_y: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if is_sensitive and then not is_cursor_over then
				on_pointer_enter
			end
		end

	on_pointer_button_press (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and then is_sensitive then
				set_pixmap_depressed
			end
		end

	on_pointer_button_release (a_x, a_y, a_button: INTEGER a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and then is_sensitive then
				set_pixmap_highlighted
			end
		end

feature {NONE} -- Implementation

	pixmap_set: EL_SVG_BUTTON_PIXMAP_SET

feature {NONE} -- Constants

	Default_pixmap_set: EL_SVG_BUTTON_PIXMAP_SET
		once
			create Result.make_default
		end

end