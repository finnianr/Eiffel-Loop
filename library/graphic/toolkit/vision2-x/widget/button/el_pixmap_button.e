note
	description: "[
		Button with experimental effect on pixmap when button is pressed
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_PIXMAP_BUTTON

inherit
	EL_BUTTON
		redefine
			initialize
		end

	EL_STRING_8_CONSTANTS

create
	default_create, make_with_pixmap_and_action

feature {NONE} -- Initialization

	initialize
		do
			Precursor {EL_BUTTON}
			pointer_button_press_actions.extend (agent on_pointer_button_press)
			pointer_button_release_actions.extend (agent on_pointer_button_release)

			create alternate_pixmap
		end

	make_with_pixmap_and_action (a_pixmap: EV_PIXMAP; a_action: PROCEDURE)
		-- experimental routine to make a "squeezable" pixmap when button is pressed
		local
			pressed: EV_PIXMAP; inner_rect: EV_RECTANGLE
			border_width: INTEGER
		do
			make_with_text_and_action (Empty_string_8, a_action)
			set_pixmap (a_pixmap)
			set_minimum_size (a_pixmap.width, a_pixmap.height)

			create pressed.make_with_size (a_pixmap.width, a_pixmap.height)
			border_width := (a_pixmap.width * 0.03).rounded
			pressed.set_background_color (background_color)
			pressed.clear
			create inner_rect.make (
				border_width - 1, border_width - 1, pixmap.width - border_width * 2,  a_pixmap.height  - border_width * 2
			)
			pressed.draw_pixmap (border_width - 1, border_width - 1, a_pixmap.sub_pixmap (inner_rect))

			alternate_pixmap.normal := a_pixmap
			alternate_pixmap.pressed := pressed
		end

feature {NONE} -- Event handlers

	on_pointer_button_press (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and then attached alternate_pixmap.pressed as pressed then
				set_pixmap (pressed)
			end
		end

	on_pointer_button_release  (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 and then attached alternate_pixmap.normal as normal then
				set_pixmap (normal)
			end
		end

feature {NONE} -- Internal attributes

	alternate_pixmap: TUPLE [pressed, normal: EV_PIXMAP]

end