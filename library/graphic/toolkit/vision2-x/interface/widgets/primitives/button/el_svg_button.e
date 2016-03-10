note
	description: "Summary description for {EL_SVG_BUTTON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 9:26:14 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_SVG_BUTTON

inherit
	EV_BUTTON
		redefine
			set_background_color
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
	make_with_pixmap_and_action

feature {NONE} -- Initialization

	make_with_pixmap_and_action (a_pixmap_set: EL_SVG_BUTTON_PIXMAP_SET; an_action: PROCEDURE [ANY, TUPLE])
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
			select_actions.extend (an_action)
			focus_out_actions.extend (agent set_pixmap_normal)
		end

feature -- Element change

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

feature -- Status report

	is_cursor_over: BOOLEAN

	disabled: BOOLEAN

feature -- Status change

	disable: BOOLEAN
			--
		do
			disabled := True
			on_pointer_leave
		end

	enable: BOOLEAN
			--
		do
			disabled := False
		end

feature {NONE} -- Event handlers

	on_pointer_enter
			--
		do
			set_pointer_style (GUI.Hyperlink_cursor)
			is_cursor_over := True
			set_pixmap_highlighted
		end

	on_pointer_leave
			--
		do
			set_pointer_style (GUI.Standard_cursor)
			is_cursor_over := False
			set_pixmap_normal
		end

	on_pointer_motion (
		a_x: INTEGER; a_y: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE;
		a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER

	)
			--
		do
			if not disabled and then not is_cursor_over then
				on_pointer_enter
			end
		end

	on_pointer_button_press (
		a_x: INTEGER; a_y: INTEGER; a_button: INTEGER
		a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER
	)
			--
		do
			if a_button = 1 then
				set_pixmap_depressed
			end
		end

	on_pointer_button_release (
		a_x: INTEGER; a_y: INTEGER; a_button: INTEGER
		a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER
	)
			--
		do
			if a_button = 1 then
				set_pixmap_highlighted
			end
		end

feature {NONE} -- Implementation

	pixmap_set: EL_SVG_BUTTON_PIXMAP_SET

end
