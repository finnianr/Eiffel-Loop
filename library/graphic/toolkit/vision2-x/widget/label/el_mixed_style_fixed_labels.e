note
	description: "Fixed area with multiple lines of labels with a mixture of font styles"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-04 14:03:02 GMT (Friday 4th September 2020)"
	revision: "5"

class
	EL_MIXED_STYLE_FIXED_LABELS

inherit
	EV_FIXED

	EL_MODULE_ITERABLE

	EL_STYLED_TEXT_LIST_DRAWABLE
		rename
			draw_text_top_left as put_label_top_left,
			draw_styled_text_list_top_left as put_styled_text_list_top_left
		undefine
			is_equal, copy, default_create
		end

create
	make, make_with_styles

feature {NONE} -- Initialization

	make (a_styled_text_lines: like styled_text_lines; a_left_margin: INTEGER; a_font: EV_FONT; a_background_color: EV_COLOR)
		do
			make_with_styles (a_styled_text_lines, a_left_margin, Font_set_cache.font_set (a_font), a_background_color)
		end

	make_with_styles (
		a_styled_text_lines: like styled_text_lines; a_left_margin: INTEGER
		a_font_table: EL_FONT_SET; a_background_color: EV_COLOR
	)
			--
		local
			max_width, l_width, l_y: INTEGER
		do
			styled_text_lines := a_styled_text_lines; left_margin := a_left_margin; font_table := a_font_table
			default_create
			create font
			set_background_color (a_background_color)

			-- Calculate maximum width
			across styled_text_lines as list loop
				l_width := font_table.mixed_style_width (list.item)
				if l_width > max_width then
					max_width := l_width
				end
			end
			set_minimum_size (max_width, font_table.line_height * Iterable.count (styled_text_lines))

			across styled_text_lines as list loop
				put_styled_text_list_top_left (left_margin, l_y, font_table, list.item)
				l_y := l_y + font_table.line_height
			end
		end

feature -- Access

	font: EV_FONT

	left_margin: INTEGER

	styled_text_lines: ITERABLE [EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]]

feature -- Element change

	set_font (a_font: EV_FONT)
		do
			font := a_font
		end

feature {NONE} -- Implementation

	put_label_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			--
		local
			label: EV_LABEL
		do
			create label.make_with_text (a_text)
			label.align_text_left
			label.set_font (font)
			label.set_background_color (background_color)
			extend (label)
			set_item_position (label, x, y)
		end

feature {NONE} -- Internal attributes

	font_table: EL_FONT_SET

end
