note
	description: "Summary description for {EL_PIXMAPABLE_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 9:26:13 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_PIXMAPABLE_LABEL

inherit
	EL_DRAWING_PIXMAP
		rename
			set_font as set_drawing_font
		end

	EV_TEXT_ALIGNMENT_CONSTANTS
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy, is_equal
		end

create
	make_with_text_and_font

feature {NONE} -- Initialization

	make_with_text_and_font (a_text: like text; a_font: like font)
			--
		do
			default_create
			pixmap := Default_pixmap
			text := a_text
			text_alignment := Ev_text_alignment_left
			set_font (a_font)
		end

feature -- Access

	pixmap: EV_PIXMAP

	text: READABLE_STRING_GENERAL

	text_alignment: INTEGER

feature -- Element change

	set_pixmap (a_pixmap: EV_PIXMAP)
			--
		do
			pixmap := a_pixmap
		end

	set_text (a_text: like text)
			--
		do
			text := a_text
			redraw
		end

	set_font (a_font: EV_FONT)
		do
			set_drawing_font (a_font)
			set_minimum_size (font.string_width (text) + font.maximum_width * 2, (font.line_height * 1.5).rounded)
		end

feature -- Status setting

	align_text_center
			-- Display `text' centered.
		do
			text_alignment := Ev_text_alignment_center
		end

	align_text_right
			-- Display `text' right aligned.
		do
			text_alignment := Ev_text_alignment_right
		end

	align_text_left
			-- Display `text' left aligned.
		do
			text_alignment := Ev_text_alignment_left
		end

feature {NONE} -- Implementation

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
			--
		local
			l_string_width, x, y: INTEGER

		do
			clear; draw_background
			l_string_width := font.string_width (text)
			inspect text_alignment
				when Ev_text_alignment_left then
					x := font.maximum_width
					y := (height - font.line_height) // 2

				when Ev_text_alignment_center then
					x := (width - l_string_width) // 2
					y := (height - font.line_height) // 2
			else
				x := width - font.maximum_width - l_string_width
				y := (height - font.line_height) // 2
			end
			set_foreground_color (text_color)
			draw_text_top_left (x, y, text)
		end

	draw_background
		do
			if pixmap /= Default_pixmap then
				draw_row_of_tiles (create {EV_RECTANGLE}.make (0, 0, width, height), pixmap)
			end
		end

	text_color: EV_COLOR
		do
			Result := GUI.Black
		end

feature {NONE} -- Constants

	Default_pixmap: EL_PIXMAP
		once
			create Result
		end

end
