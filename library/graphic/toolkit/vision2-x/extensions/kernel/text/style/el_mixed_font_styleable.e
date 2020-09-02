note
	description: "Routines for label components with mixed font styles"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-02 11:16:50 GMT (Wednesday 2nd September 2020)"
	revision: "6"

deferred class
	EL_MIXED_FONT_STYLEABLE

inherit
	EL_MODULE_GUI

	EL_STRING_8_CONSTANTS

	EL_TEXT_STYLE
		export
			{NONE} all
			{ANY} is_valid_style
		end

feature {NONE} -- Initialization

	make (a_font, a_fixed_font: EV_FONT)
		do
			create font_table.make_filled (a_font, 4)
			font_table [Monospaced] := a_fixed_font
			font_table [Bold] := a_font.twin
			font_table.item (Bold).set_weight (GUI.Weight_bold)

			font_table [Monospaced_bold] := a_fixed_font.twin
			font_table.item (Monospaced_bold).set_weight (GUI.Weight_bold)

			line_height := font_table.item (Bold).line_height.max (font_table.item (Monospaced_bold).line_height)
		end

feature -- Access

	font: EV_FONT
		deferred
		end

feature -- Measurement

	mixed_style_width (text_list: EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]): INTEGER
		local
			l_space_width: INTEGER
		do
			l_space_width := space_width

			from text_list.start until text_list.after loop
				Result :=  Result + string_width (text_list.item_style, text_list.item_text)
				if not text_list.islast then
					Result := Result + l_space_width
				end
				text_list.forth
			end
		end

	space_width: INTEGER
		do
			Result := font_table.item (Regular).string_width (character_string_8 (' '))
		end

	line_height: INTEGER

feature -- Element change

	set_style_font (style: INTEGER)
		require
			valid_style: is_valid_style (style)
		do
			set_font (font_table [style])
		end

feature {NONE} -- Implementation

	default_fixed_font (a_font: EV_FONT): EV_FONT
		do
			create {EL_FONT} Result.make_with_values (
				GUI.Family_typewriter, GUI.Weight_regular, GUI.Shape_regular, a_font.height
			)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		deferred
		end

	draw_mixed_style_text_top_left (x, y: INTEGER; text_list: EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL])
		local
			l_x, l_space_width: INTEGER
		do
			l_space_width := space_width; l_x := x

			from text_list.start until text_list.after loop
				set_style_font (text_list.item_style)
				draw_text_top_left (l_x, y, text_list.item_text)
				l_x := l_x + string_width (text_list.item_style, text_list.item_text)
				if not text_list.islast then
					l_x := l_x + l_space_width
				end
				text_list.forth
			end
		end

	leading_spaces_width (style: INTEGER; string: READABLE_STRING_GENERAL): INTEGER
			-- width of leading spaces in `text' for `a_styleable' component
		local
			i: INTEGER
		do
			from i := 1 until i > string.count or else string [i] /= ' ' loop
				i := i + 1
			end
			Result := string_width (style, n_character_string_8 (' ', i - 1))
		end

	set_font (a_font: EV_FONT)
			--
		deferred
		end

	string_width (style: INTEGER; string: READABLE_STRING_GENERAL): INTEGER
		do
			Result := GUI.string_width (string, font_table [style])
		end

feature {NONE} -- Internal attributes

	font_table: SPECIAL [EV_FONT]

end
