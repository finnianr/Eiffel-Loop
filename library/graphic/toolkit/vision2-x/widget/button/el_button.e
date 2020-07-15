note
	description: "Button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-15 11:16:30 GMT (Wednesday 15th July 2020)"
	revision: "8"

class
	EL_BUTTON

inherit
	EV_BUTTON
		redefine
			initialize, set_text
		end

	EL_HAND_POINTER_BUTTON
		redefine
			initialize
		end

	EL_MODULE_GUI

	EL_MODULE_SCREEN

	EL_ZSTRING_CONSTANTS

	EL_MODULE_ZSTRING

create
	default_create,
	make_with_text,
	make_with_text_and_action,
	make_with_pixmap_and_action

feature {NONE} -- Initialization

	initialize
		do
			Precursor {EV_BUTTON}
			Precursor {EL_HAND_POINTER_BUTTON}
			pointer_button_press_actions.extend (agent on_pointer_button_press)
			pointer_button_release_actions.extend (agent on_pointer_button_release)

			create alternate_pixmap
		end

	make_with_pixmap_and_action (a_pixmap: EV_PIXMAP; a_action: PROCEDURE)
			--
		local
			new_pixmap: EV_PIXMAP; inner_rect: EV_RECTANGLE
			border_width: INTEGER
		do
			make_with_text_and_action (Empty_string, a_action)
			set_pixmap (a_pixmap)
			set_minimum_size (a_pixmap.width, a_pixmap.height)

			create new_pixmap.make_with_size (a_pixmap.width, a_pixmap.height)
			border_width := (a_pixmap.width * 0.03).rounded
			new_pixmap.set_background_color (background_color)
			new_pixmap.clear
			create inner_rect.make (
				border_width - 1, border_width - 1, pixmap.width - border_width * 2,  a_pixmap.height  - border_width * 2
			)
			new_pixmap.draw_pixmap (border_width - 1, border_width - 1, a_pixmap.sub_pixmap (inner_rect))

			alternate_pixmap.bigger := a_pixmap
			alternate_pixmap.smaller := new_pixmap
		end

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			Precursor (Zstring.to_unicode_general (a_text))
		end

feature {NONE} -- Event handlers

	on_pointer_button_press (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 then
				squeeze
			end
		end

	on_pointer_button_release  (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			--
		do
			if a_button = 1 then
				unsqueeze
			end
		end

feature {NONE} -- Implementation

	squeeze
			--
		do
			if attached alternate_pixmap.smaller as smaller then
				set_pixmap (smaller)
			end
		end

	unsqueeze
			--
		do
			if attached alternate_pixmap.bigger as bigger then
				set_pixmap (bigger)
			end
		end

feature {NONE} -- Internal attributes

	alternate_pixmap: TUPLE [smaller, bigger: EV_PIXMAP]

end
