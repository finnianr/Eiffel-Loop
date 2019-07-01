note
	description: "Box with linked HTML color text box and color dialog button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 7:43:09 GMT (Friday 21st December 2018)"
	revision: "5"

class
	EL_MULTI_MODE_HTML_COLOR_SELECTOR_BOX

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

	EL_STRING_32_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

	EL_MODULE_GUI

	EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make (
		a_border_cms, a_padding_cms: REAL; a_window: EV_WINDOW
		label_text, tooltip_text, color_selection_text: READABLE_STRING_GENERAL
		RGB_color_code: INTEGER; set_color: PROCEDURE [EL_COLOR]
	)
		local
			html_color_code, longest_html_color_code: STRING
		do
			make_box (a_border_cms, a_padding_cms)
			html_color_code := GUI.rgb_code_to_html_code (RGB_color_code)
			create code_field
			code_field.set_capacity (7)
			create longest_html_color_code.make_filled ('D', 7)
			code_field.set_minimum_width_in_characters (longest_html_color_code.count)
			code_field.set_text (html_color_code)
			if not tooltip_text.is_empty then
				code_field.set_tooltip (tooltip_text.to_string_32)
			end
			create color_button.make (
				a_window, color_selection_text.to_string_32 + character_string_32 (' ') + label_text.to_string_32.as_lower,
				code_field.height, RGB_color_code,
				agent on_color_select (?, set_color)
			)
			code_field.focus_out_actions.extend (agent set_color_on_focus_out (set_color))
			code_field.change_actions.extend (agent on_code_field_change (set_color))
			append_unexpanded (<< code_field, color_button >>)
		end

feature {NONE} -- Event handling

	on_code_field_change (set_color: PROCEDURE [EL_COLOR])
		local
			text: STRING_32; valid: BOOLEAN
			color: EL_COLOR
		do
			text := code_field.text
			if text.count = 7 then
				valid := True
				across text as char until not valid loop
					if char.cursor_index = 1  then
						valid := char.item = '#'
					else
						inspect char.item.code
							when 48 .. 57, 65 .. 70, 97 .. 102 then
						else
							valid := False
						end
					end
				end
				if valid then
					create color.make_with_html (text)
					color_button.set_color (color.rgb_24_bit)
					set_color (color)
				end
			end
		end

	on_color_select (RGB_color_code: INTEGER; set_color: PROCEDURE [EL_COLOR])
		local
			color: EL_COLOR
		do
			create color.make_with_rgb_24_bit (RGB_color_code)
			code_field.change_actions.block
			code_field.set_text (color.html_color)
			code_field.change_actions.resume
			set_color (color)
		end

feature {NONE} -- Implementation

	set_color_on_focus_out (set_color_action: PROCEDURE [EV_COLOR])
		local
			color: EL_COLOR
		do
			create color.make_with_html (code_field.text)
			if color_button.color /~ color then
				color_button.set_color (color.rgb_24_bit)
				set_color_action.call ([color])
			end
		end

feature {NONE} -- Internal attributes

	code_field: EV_TEXT_FIELD

	color_button: EL_COLOR_BUTTON

end
