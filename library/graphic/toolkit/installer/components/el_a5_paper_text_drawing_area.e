note
	description: "A5 paper text drawing area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 10:38:29 GMT (Saturday 23rd October 2021)"
	revision: "9"

class
	EL_A5_PAPER_TEXT_DRAWING_AREA

inherit
	EL_DRAWING_AREA_BASE

	EL_UI_COMPONENT_FACTORY
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN

	EL_MODULE_GUI

	EL_SHARED_INSTALL_TEXTS

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			set_expose_actions
		end

feature {NONE} -- Event handlers

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
		local
			rect: EL_RECTANGLE; text_rect: EL_TEXT_RECTANGLE; title_height: INTEGER
			font_3: like new_font
		do
			clear
			if width = a_width then
				font_3 := new_font (Size.medium)
				set_font (new_font (Size.large)); set_foreground_color (Color.Black)
				title_height := font.line_height

				create rect.make (0, 0, a_width, title_height)
				draw_centered_text (Text.setup_title, rect)

				set_font (new_font (Size.hugh))
				rect.set_y (rect.height + Screen.vertical_pixels (1))
				rect.set_height (font.line_height)
				rect.set_width (font_3.string_width (Text.A5_dimensions))
				set_foreground_color (Color.Blue)
				draw_text_top_left (rect.x, rect.y, Text_A5)

				set_font (font_3)
				rect.move (rect.x, rect.y + rect.height)
				rect.set_height (font.line_height)
				set_foreground_color (Color.Black)
				draw_centered_text (Text.A5_dimensions, rect)

				create text_rect.make (rect.width, title_height, width - rect.width, height - title_height)
				text_rect.grow_top (Screen.vertical_pixels (1.0).opposite)
				text_rect.grow_left (Screen.horizontal_pixels (1.0).opposite)

				text_rect.set_font (new_font (Size.tiny))
				text_rect.append_paragraphs (Text.A5_instructions, 0.2)
				text_rect.draw (Current)
			end
		end

feature {NONE} -- Factory

	new_word_list: EL_ZSTRING_LIST
		do
			create Result.make (50)
		end

feature {NONE} -- Constants

	Text_A5: STRING = "A5"

end