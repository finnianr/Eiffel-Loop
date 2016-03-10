note
	description: "Summary description for {EL_BUTTON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-22 16:05:56 GMT (Monday 22nd December 2014)"
	revision: "3"

class
	EL_BUTTON

inherit
	EV_BUTTON

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
	make, make_with_pixmap_and_action

feature {NONE} -- Initialization

	 make
			--
		do
			default_create
			pointer_enter_actions.extend (agent on_pointer_enter)
			pointer_leave_actions.extend (agent on_pointer_leave)
			pointer_motion_actions.extend (agent on_pointer_motion)
			pointer_button_press_actions.extend (agent on_pointer_button_press)
			pointer_button_release_actions.extend (agent on_pointer_button_release)
		end

	make_with_pixmap_and_action (a_pixmap: EV_PIXMAP; an_action: PROCEDURE [ANY, TUPLE])
			--
		do
			make
			set_pixmap (a_pixmap)
			set_minimum_size (a_pixmap.width, a_pixmap.height)
			-- + graphics_system.centimetre_pixels_x (0.2)
			select_actions.extend (an_action)
			pixmap_at_start := a_pixmap
		end

feature -- Access

	pixmap_at_start: EV_PIXMAP

feature -- Status report

	is_cursor_over: BOOLEAN

	disabled: BOOLEAN

feature -- Status change

	disable: BOOLEAN
			--
		do
			disabled := True
			on_pointer_leave
			squeeze
		end

	enable: BOOLEAN
			--
		do
			disabled := False
			unsqueeze
		end

feature -- Element change

	set_fixed (a_fixed: EV_FIXED; a_offset: INTEGER)
			--
		do
			fixed := a_fixed
			offset := a_offset
		end

feature {NONE} -- Event handlers

	on_pointer_enter
			--
		do
			set_pointer_style (GUI.Hyperlink_cursor)
			is_cursor_over := True
--			background_color_at_start := background_color
--			set_background_color (GUI.Red)
		end

	on_pointer_leave
			--
		do
			set_pointer_style (GUI.Standard_cursor)
			is_cursor_over := False
--			set_background_color (background_color_at_start)
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
				squeeze
			end
		end

	on_pointer_button_release (
		a_x: INTEGER; a_y: INTEGER; a_button: INTEGER
		a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER
	)
			--
		do
			if a_button = 1 then
				unsqueeze
			end
		end

feature {NONE} -- Implementation

	squeeze
			--
		local
			new_pixmap: EV_PIXMAP
			border_width: INTEGER
			inner_rect: EV_RECTANGLE
		do
			create new_pixmap.make_with_size (pixmap.width, pixmap.height)
			border_width := (pixmap.width * 0.03).rounded
			new_pixmap.set_background_color (background_color)
			new_pixmap.clear
			create inner_rect.make (border_width - 1, border_width - 1, pixmap.width - border_width * 2,  pixmap.height  - border_width * 2)
			new_pixmap.draw_pixmap (border_width - 1, border_width - 1, pixmap.sub_pixmap (inner_rect))
			set_pixmap (new_pixmap)
		end

	unsqueeze
			--
		do
			set_pixmap (pixmap_at_start)
		end

	fixed: EV_FIXED

	offset: INTEGER
end
