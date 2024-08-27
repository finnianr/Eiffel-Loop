note
	description: "Set of fonts corresponding to the 4 font styles defined by ${EL_TEXT_STYLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 10:00:09 GMT (Tuesday 27th August 2024)"
	revision: "8"

class
	EL_FONT_SET

inherit
	ARRAY [EV_FONT]
		rename
			make as make_array,
			item as font
		export
			{NONE} all
			{ANY} font
		redefine
			make_from_array
		end

	EL_TEXT_STYLE
		export
			{NONE} all
			{ANY} is_valid_style
		undefine
			copy, is_equal
		end

	EL_MODULE_TEXT

	EL_CHARACTER_8_CONSTANTS

create
	make, make_monospace_default, make_from_array

feature {NONE} -- Initialization

	make (a_font, a_monospace_font: EV_FONT)
		do
			make_filled (a_font, 1, 4)
			put (a_monospace_font, Monospaced)
			put (a_font.twin, Bold)
			font (Bold).set_weight (Text_.Weight_bold)

			put (a_monospace_font.twin, Monospaced_bold)
			font (Monospaced_bold).set_weight (Text_.Weight_bold)

			line_height := font (Bold).line_height.max (font (Monospaced_bold).line_height)
		end

	make_from_array (a: ARRAY [EV_FONT])
		require else
			count_is_4: a.count = 4
			valid_regular: a.item (Regular).weight = Text_.Weight_regular and a.item (Regular).is_proportional
			valid_bold: a.item (Bold).weight = Text_.Weight_bold and a.item (Bold).is_proportional
			valid_monospaced: a.item (Monospaced).weight = Text_.Weight_regular and not a.item (Monospaced).is_proportional
			valid_monospaced_bold:
				a.item (Monospaced_bold).weight = Text_.Weight_bold and not a.item (Monospaced_bold).is_proportional
		do
			Precursor (a)
			line_height := font (Bold).line_height.max (font (Monospaced_bold).line_height)
		end

	make_monospace_default (a_font: EV_FONT)
		local
			monospace: EL_FONT
		do
			create monospace.make_with_values (
				Text_.Family_typewriter, Text_.Weight_regular, Text_.Shape_regular, a_font.height
			)
			make (a_font, monospace)
		end

feature -- Measurement

	item_string_width (text_list: EL_STYLED_TEXT_LIST [STRING_GENERAL]): INTEGER
		do
			if not text_list.off then
				Result := Text_.string_width (text_list.item_text, font (text_list.item_style))
			end
		end

	leading_spaces_width (text_list: EL_STYLED_TEXT_LIST [STRING_GENERAL]): INTEGER
			-- width of leading spaces in `text_list.first_text'
		local
			i: INTEGER; string: READABLE_STRING_GENERAL
		do
			if text_list.count > 0 then
				string := text_list.first_text
				from i := 1 until i > string.count or else string [i] /= ' ' loop
					i := i + 1
				end
				Result := font (text_list.first_style).string_width (space * (i - 1))
			end
		end

	line_height: INTEGER

	mixed_style_width (text_list: EL_STYLED_TEXT_LIST [STRING_GENERAL]): INTEGER
		local
			l_space_width: INTEGER
		do
			l_space_width := regular_space_width

			from text_list.start until text_list.after loop
				Result :=  Result + item_string_width (text_list)
				if not text_list.islast then
					Result := Result + l_space_width
				end
				text_list.forth
			end
		end

	regular_space_width: INTEGER
		do
			Result := font (Regular).string_width (space * 1)
		end

end