note
	description: "[
		Drawable component that can draw string lists with a mix of font-styles conforming to [$source EL_STYLED_TEXT_LIST]
	]"
	notes: "[
		`draw_text_top_left' can be implemented either as `{EV_DRAWING_AREA}.draw_text_top_left' or as
		`{EV_FIXED}.put_label_top_left'. See class [$source EL_MIXED_STYLE_FIXED_LABELS] for example of latter.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_STYLED_TEXT_LIST_DRAWABLE

feature {NONE} -- Implementation

	draw_styled_text_list_top_left (
		x, y: INTEGER; font_set: EL_FONT_SET; text_list: EL_STYLED_TEXT_LIST [STRING_GENERAL]
	)
		local
			l_x, l_space_width: INTEGER
		do
			l_space_width := font_set.regular_space_width; l_x := x

			from text_list.start until text_list.after loop
				set_font (font_set.font (text_list.item_style))
				draw_text_top_left (l_x, y, text_list.item_text)
				l_x := l_x + font_set.item_string_width (text_list)
				if not text_list.islast then
					l_x := l_x + l_space_width
				end
				text_list.forth
			end
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		deferred
		end

	set_font (a_font: EV_FONT)
			--
		deferred
		end

feature {NONE} -- Constants

	Font_set_cache: EL_FONT_SET_CACHE
		once
			create Result.make_equal (11)
		end
end