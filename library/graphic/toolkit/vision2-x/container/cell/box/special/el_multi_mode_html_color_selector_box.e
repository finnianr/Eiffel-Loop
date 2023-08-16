note
	description: "Box with linked HTML color text box and color dialog button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-09 11:13:40 GMT (Wednesday 9th August 2023)"
	revision: "12"

class
	EL_MULTI_MODE_HTML_COLOR_SELECTOR_BOX

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_COLOR
		rename
			Color as Colors
		end

	EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make (
		a_border_cms, a_padding_cms: REAL; a_window: EV_WINDOW
		label_text, tooltip_text, color_selection_text: READABLE_STRING_GENERAL
		target_color: EV_COLOR
	)
		-- create color selection box to edit `target_color'
		do
			make_box (a_border_cms, a_padding_cms)
			color := target_color

			create code_field
			code_field.set_capacity (Longest_html_color_code.count)
			code_field.set_minimum_width_in_characters (Longest_html_color_code.count)
			code_field.set_text (Colors.rgb_code_to_html_code (target_color.rgb_24_bit))
			code_field.focus_out_actions.extend (agent set_color_on_focus_out)
			code_field.change_actions.extend (agent on_code_field_change)
			if not tooltip_text.is_empty then
				code_field.set_tooltip (tooltip_text.to_string_32)
			end

			create listeners.make
			create color_button.make (
				a_window, Text_template #$ [color_selection_text, label_text.as_lower],
				code_field.height, target_color.rgb_24_bit, agent on_color_select
			)
			append_unexpanded (<< code_field, color_button >>)
		end

feature -- Access

	listeners: EL_EVENT_BROADCASTER
		-- event listeners that will be notified after `on_select_value' is called

feature {NONE} -- Event handling

	on_code_field_change
		local
			text: STRING_32
		do
			text := code_field.text
			if Colors.valid_html_code (text) then
				set_color_rgb (Colors.html_code_to_rgb_code (text))
			end
		end

	on_color_select (RGB_color_code: INTEGER)
		do
			code_field.change_actions.block
			code_field.set_text (Colors.rgb_code_to_html_code (RGB_color_code))
			code_field.change_actions.resume
			set_color_rgb (RGB_color_code)
		end

feature {NONE} -- Implementation

	set_color_on_focus_out
		local
			rgb_24_bit: INTEGER; text: STRING_32
		do
			text := code_field.text
			if Colors.valid_html_code (text) then
				rgb_24_bit := Colors.html_code_to_rgb_code (text)
				if color_button.color.rgb_24_bit /= rgb_24_bit then
					color_button.set_color (rgb_24_bit)
					set_color_rgb (rgb_24_bit)
				end
			end
		end

	set_color_rgb (RGB_color_code: INTEGER)
		do
			color.set_rgb_with_24_bit (RGB_color_code)
			listeners.notify
		end

feature {NONE} -- Internal attributes

	code_field: EV_TEXT_FIELD

	color: EV_COLOR
		-- target color to edit

	color_button: EL_COLOR_BUTTON

feature {NONE} -- Constants

	Longest_html_color_code: STRING
		once
			create Result.make_filled ('D', 7)
		end

	Text_template: ZSTRING
		once
			Result := "%S %S"
		end
end