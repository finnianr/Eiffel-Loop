note
	description: "[
		Fixed area with multiple lines of labels with a mixture of font styles.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "7"

class
	EL_MIXED_STYLE_FIXED_LABELS

inherit
	EV_FIXED

	EL_MIXED_FONT_STYLEABLE
		rename
			make as make_mixed_font,
			draw_text_top_left as put_label_top_left,
			draw_mixed_style_text_top_left as put_mixed_style_text_top_left
		undefine
			is_equal, copy, default_create
		end

create
	make, make_with_styles

feature {NONE} -- Initialization

	make (a_styled_text_lines: like styled_text_lines; a_left_margin: INTEGER; a_font: EV_FONT; a_background_color: EV_COLOR)
		do
			make_with_styles (a_styled_text_lines, a_left_margin, a_font, default_fixed_font (a_font), a_background_color)
		end

	make_with_styles (
		a_styled_text_lines: like styled_text_lines; a_left_margin: INTEGER
		a_font, a_fixed_font: EV_FONT; a_background_color: EV_COLOR
	)
			--
		local
			max_width, l_width, l_count, i, l_y: INTEGER
		do
			styled_text_lines := a_styled_text_lines; left_margin := a_left_margin
			make_mixed_font (a_font, a_fixed_font)
			default_create
			create font
			set_background_color (a_background_color)

			-- Calculate maximum width
			l_count := a_styled_text_lines.index_set.upper
			from i := a_styled_text_lines.index_set.lower until i > l_count loop
				l_width := mixed_style_width (styled_text_lines [i])
				if l_width > max_width then
					max_width := l_width
				end
				i := i + 1
			end
			set_minimum_size (max_width, bold_font.line_height * styled_text_lines.index_set.count)

			from i := a_styled_text_lines.index_set.lower until i > l_count loop
				put_mixed_style_text_top_left (left_margin, l_y, a_styled_text_lines [i])
				l_y := l_y + bold_font.line_height
				i := i + 1
			end
		end

feature -- Access

	styled_text_lines: INDEXABLE [EL_MIXED_STYLE_STRING_LIST, INTEGER]

	font: EV_FONT

	left_margin: INTEGER

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

end
