note
	description: "A5/A4 paper-sheet text drawing area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-06 11:12:25 GMT (Thursday 6th July 2023)"
	revision: "12"

class
	EL_PAPER_SHEET_DRAWING_AREA

inherit
	EL_DRAWING_AREA_BASE

	EL_UI_COMPONENT_FACTORY
		undefine
			default_create, copy
		end

	EL_MODULE_ACTION; EL_MODULE_SCREEN

	EL_SHARED_INSTALL_TEXTS

	EL_PAPER_SIZE_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (a_paper_code: NATURAL_8)
		do
			paper_code := a_paper_code
			default_create
			set_expose_actions
		end

feature {NONE} -- Event handlers

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
		local
			rect: EL_RECTANGLE; text_rect: EL_TEXT_RECTANGLE; title_height: INTEGER
			font_3: like new_font; paper_dimensions: ZSTRING
		do
			clear
			if width = a_width then
				paper_dimensions := Text.size_template #$ Dimension_table [paper_code]

				font_3 := new_font (Size.medium)
				set_font (new_font (Size.large)); set_foreground_color (Color.Black)
				title_height := font.line_height

				create rect.make (0, 0, a_width, title_height)
				draw_centered_text (Text.setup_title, rect)

				set_font (new_font (Size.hugh))
				rect.set_y (rect.height + Screen.vertical_pixels (1))
				rect.set_height (font.line_height)
				rect.set_width ((font_3.string_width (Text.landscape_orientation) * 1.1).rounded)
				set_foreground_color (Color.Blue)
				draw_centered_text (code_name (paper_code), rect)

				set_font (font_3)
				rect.move (rect.x, rect.y + rect.height)
				rect.set_height (font.line_height)
				set_foreground_color (Color.Black)
				draw_centered_text (Text.landscape_orientation, rect)

				rect.move (rect.x, rect.y + rect.height)
				draw_centered_text (paper_dimensions, rect)

				create text_rect.make (rect.width, title_height, width - rect.width, height - title_height)
				text_rect.grow_top (Screen.vertical_pixels (1.0).opposite)
				text_rect.grow_left (Screen.horizontal_pixels (1.0).opposite)

				text_rect.set_font (new_font (Size.tiny))
				text_rect.append_paragraphs (Text.paper_instructions (paper_code), 0.2)
				text_rect.draw (Current)
			end
		end

feature {NONE} -- Factory

	new_word_list: EL_ZSTRING_LIST
		do
			create Result.make (50)
		end

feature {NONE} -- Internal attributes

	paper_code: NATURAL_8

end