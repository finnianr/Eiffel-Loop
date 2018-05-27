note
	description: "Mixed style label area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_MIXED_STYLE_LABEL_AREA

inherit
	EL_DRAWING_AREA_BASE

	EL_MIXED_FONT_STYLEABLE
		rename
			make as make_mixed_font
		undefine
			copy, default_create
		end

create
	make, make_with_styles

feature {NONE} -- Initialization

	make (a_styled_text: like styled_text; a_font: EV_FONT; a_background_color: EV_COLOR)
		do
			make_with_styles (a_styled_text, a_font, default_fixed_font (a_font), a_background_color)
		end

	make_with_styles (a_styled_text: like styled_text; a_font, a_fixed_font: EV_FONT; a_background_color: EV_COLOR)
			--
		do
			styled_text := a_styled_text
			make_mixed_font (a_font, a_fixed_font)
			default_create
			set_background_color (a_background_color)
			set_minimum_size (mixed_style_width (styled_text) , bold_font.line_height)
			set_expose_actions
		end

feature -- Access

	styled_text: EL_MIXED_STYLE_TEXT_LIST

feature {NONE} -- Implementation

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
			--
		do
			clear
			set_foreground_color (GUI.Black)
			draw_mixed_style_text_top_left (0, 0, styled_text)
		end
end
