note
	description: "Box with linked HTML color text box and color dialog button"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 7:42:30 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_MULTI_MODE_HTML_COLOR_SELECTOR_BOX

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box
		end

	EL_MODULE_GUI
		undefine
			is_equal, default_create, copy
		end

	EL_MODULE_VISION_2
		undefine
			is_equal, default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_border_cms, a_padding_cms: REAL; a_window: EV_WINDOW
		label_text, tooltip_text, color_selection_text: ZSTRING
		RGB_color_code: INTEGER; set_color_action: PROCEDURE [ANY, TUPLE [EL_COLOR]]
	)
		local
			code_field: EV_TEXT_FIELD
			html_color_code, longest_html_color_code: STRING
			color_button: EL_COLOR_BUTTON
			l_label_text: ZSTRING
		do
			make_box (a_border_cms, a_padding_cms)
			html_color_code := GUI.rgb_code_to_html_code (RGB_color_code)
			create code_field
			code_field.set_capacity (7)
			create longest_html_color_code.make_filled ('D', 7)
			code_field.set_minimum_width_in_characters (longest_html_color_code.count)
			code_field.set_text (html_color_code)
			if not tooltip_text.is_empty then
				code_field.set_tooltip (tooltip_text.to_unicode)
			end
			create l_label_text.make_from_other (color_selection_text)
			l_label_text.append_character (' ')
			l_label_text.append (label_text.as_lower)
			create color_button.make (
				a_window, l_label_text.to_unicode, code_field.height, RGB_color_code,
				agent on_color_select (?, code_field, set_color_action)
			)
			code_field.focus_out_actions.extend (agent set_color_on_focus_out (code_field, color_button, set_color_action))
			append_unexpanded (<< code_field, color_button >>)
		end

feature {NONE} -- Event handling

	on_color_select (RGB_color_code: INTEGER; code_field: EV_TEXT_FIELD; set_color_action: PROCEDURE [ANY, TUPLE [EV_COLOR]])
		do
			code_field.set_text (GUI.rgb_code_to_html_code (RGB_color_code))
			set_color_action.call ([Vision_2.new_color (RGB_color_code)])
		end

feature {NONE} -- Implementation

	set_color_on_focus_out (
		html_code_field: EV_TEXT_FIELD; color_button: EL_COLOR_BUTTON
		set_color_action: PROCEDURE [ANY, TUPLE [EV_COLOR]]
	)
		local
			l_color: EL_COLOR
		do
			l_color:= Vision_2.new_color (GUI.html_code_to_rgb_code (html_code_field.text))
			if color_button.color /~ l_color then
				color_button.set_color (l_color.rgb_24_bit)
				set_color_action.call ([l_color])
			end
		end
end