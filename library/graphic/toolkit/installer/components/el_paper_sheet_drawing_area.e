note
	description: "A5/A4 paper-sheet text drawing area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 16:06:53 GMT (Friday 7th July 2023)"
	revision: "15"

class
	EL_PAPER_SHEET_DRAWING_AREA

inherit
	EL_DRAWING_AREA_BASE

	EL_UI_COMPONENT_FACTORY
		undefine
			default_create, copy
		end

	EL_MODULE_ACTION; EL_MODULE_SCREEN

	EL_SHARED_INSTALL_TEXTS; EL_SHARED_PAPER_DIMENSIONS

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
				rect.set_width ((font_3.string_width (Text.landscape_orientation) * 1.1).rounded)
				set_foreground_color (Color.Blue)
				draw_centered_text (paper.id, rect)

				set_font (font_3)
				rect.move (rect.x, rect.y + rect.height)
				rect.set_height (font.line_height)
				set_foreground_color (Color.Black)
				draw_centered_text (Text.landscape_orientation, rect)

				rect.move (rect.x, rect.y + rect.height)
				draw_centered_text (size_description, rect)

				create text_rect.make (rect.width, title_height, width - rect.width, height - title_height)
				text_rect.grow_top (Screen.vertical_pixels (1.0).opposite)
				text_rect.grow_left (Screen.horizontal_pixels (1.0).opposite)

				text_rect.set_font (new_font (Size.tiny))
				text_rect.append_paragraphs (paper_instructions, 0.2)
				text_rect.draw (Current)
			end
		end

feature {NONE} -- Implementation

	new_word_list: EL_ZSTRING_LIST
		do
			create Result.make (50)
		end

	paper_instructions: EL_ZSTRING_LIST
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.new_paragraph_list (Text.matching_instruction_template #$ [paper.id])
			if paper.is_A5 then
				Result.append (s.new_paragraph_list (Text.A5_tip))
			end
		end

	size_description: ZSTRING
		do
			Result := Text.size_template #$ paper.as_tuple
		end

end