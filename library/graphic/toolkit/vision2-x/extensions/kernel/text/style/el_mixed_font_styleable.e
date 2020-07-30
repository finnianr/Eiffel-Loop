note
	description: "Routines for label components with mixed font styles"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 12:03:13 GMT (Friday 21st December 2018)"
	revision: "5"

deferred class
	EL_MIXED_FONT_STYLEABLE

inherit
	EL_MIXED_FONT_STYLEABLE_I

	EL_MODULE_GUI

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make (a_font, a_fixed_font: EV_FONT)
		do
			regular_font := a_font
			monospaced_font := a_fixed_font

			bold_font := a_font.twin
			bold_font.set_weight (GUI.Weight_bold)

			monospaced_bold_font := a_fixed_font.twin
			monospaced_bold_font.set_weight (GUI.Weight_bold)
		end

feature -- Access

	bold_font: EV_FONT

	monospaced_bold_font: EV_FONT

	monospaced_font: EV_FONT

	regular_font: EV_FONT

feature -- Measurement

	bold_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := GUI.string_width (text, bold_font)
		end

	mixed_style_width (a_mixed_text: FINITE [EL_STYLED_TEXT]): INTEGER
		local
			count, l_space_width: INTEGER;
			text_list: LINEAR [EL_STYLED_TEXT]
		do
			count := a_mixed_text.count; l_space_width := space_width
			text_list := a_mixed_text.linear_representation

			from text_list.start until text_list.after loop
				Result :=  Result + text_list.item.width (Current)
				if text_list.index < count then
					Result := Result + l_space_width
				end
				text_list.forth
			end
		end

	monospaced_bold_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := GUI.string_width (text, monospaced_bold_font)
		end

	monospaced_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := GUI.string_width (text, monospaced_font)
		end

	regular_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := GUI.string_width (text, regular_font)
		end

	space_width: INTEGER
		do
			Result := regular_font.string_width (character_string_8 (' '))
		end

feature -- Element change

	set_bold
		do
			set_font (bold_font)
		end

	set_font (a_font: EV_FONT)
			--
		deferred
		end

	set_monospaced
		do
			set_font (monospaced_font)
		end

	set_monospaced_bold
		do
			set_font (monospaced_bold_font)
		end

	set_regular
		do
			set_font (regular_font)
		end

feature -- Drawing operations

	draw_mixed_style_text_top_left (x, y: INTEGER; a_mixed_text: FINITE [EL_STYLED_TEXT])
		local
			l_x, count, l_space_width: INTEGER
			i_th_text: EL_STYLED_TEXT; text_list: LINEAR [EL_STYLED_TEXT]
		do
			l_space_width := space_width;  l_x := x
			text_list := a_mixed_text.linear_representation; count := a_mixed_text.count

			from text_list.start until text_list.after loop
				i_th_text := text_list.item
				i_th_text.change_font (Current)
				draw_text_top_left (l_x, y, i_th_text.as_string_32)
				l_x := l_x + i_th_text.width (Current)
				if text_list.index < count then
					l_x := l_x + l_space_width
				end
				text_list.forth
			end
		end

feature -- EV_DRAWABLE routines

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		deferred
		end

feature -- Conversion

	default_fixed_font (a_font: EV_FONT): EV_FONT
		do
			create {EL_FONT} Result.make_with_values (
				GUI.Family_typewriter, GUI.Weight_regular, GUI.Shape_regular, a_font.height
			)
		end

end
