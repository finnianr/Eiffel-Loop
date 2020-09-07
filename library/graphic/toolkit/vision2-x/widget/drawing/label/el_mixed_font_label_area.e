note
	description: "Mixed style label area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-05 9:27:11 GMT (Saturday 5th September 2020)"
	revision: "9"

class
	EL_MIXED_FONT_LABEL_AREA

inherit
	EL_DRAWING_AREA_BASE

	EL_STYLED_TEXT_LIST_DRAWABLE
		undefine
			copy, default_create
		end

	EL_MODULE_COLOR

create
	make, make_with_styles

feature {NONE} -- Initialization

	make (a_styled_text: like styled_text; a_font: EV_FONT; a_background_color: EV_COLOR)
		do
			make_with_styles (a_styled_text, Font_set_cache.font_set (font), a_background_color)
		end

	make_with_styles (a_styled_text: like styled_text; a_font_set: EL_FONT_SET; a_background_color: EV_COLOR)
			--
		do
			styled_text := a_styled_text; font_set := a_font_set
			default_create
			set_background_color (a_background_color)
			set_minimum_size (font_set.mixed_style_width (styled_text), font_set.line_height)
			set_expose_actions
		end

feature -- Access

	styled_text: EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]

feature {NONE} -- Implementation

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
			--
		do
			clear
			set_foreground_color (Color.Black)
			draw_styled_text_list_top_left (0, 0, font_set, styled_text)
		end

feature {NONE} -- Internal attributes

	font_set: EL_FONT_SET

end
