note
	description: "Routines for label components with mixed font styles"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:23:48 GMT (Saturday 26th December 2015)"
	revision: "5"

deferred class
	EL_MIXED_FONT_STYLEABLE

inherit
	EL_MIXED_FONT_STYLEABLE_I

	EL_MODULE_GUI

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

	regular_font: EV_FONT

	bold_font: EV_FONT

	monospaced_font: EV_FONT

	monospaced_bold_font: EV_FONT

feature -- Measurement

	mixed_style_width (a_mixed_text: INDEXABLE [EL_STYLED_ZSTRING, INTEGER]): INTEGER
		local
			i, l_upper, l_space_width: INTEGER
		do
			l_upper := a_mixed_text.index_set.upper
			l_space_width := space_width
			from i := a_mixed_text.index_set.lower until i > l_upper loop
				Result :=  Result + a_mixed_text.item (i).width (Current)
				if i < l_upper then
					Result := Result + l_space_width
				end
				i := i + 1
			end
		end

	bold_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := bold_font.string_width (text)
		end

	monospaced_bold_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := monospaced_bold_font.string_width (text)
		end

	regular_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := regular_font.string_width (text)
		end

	monospaced_width (text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := monospaced_font.string_width (text)
		end

	space_width: INTEGER
		do
			Result := regular_font.string_width (" ")
		end

feature -- Element change

	set_bold
		do
			set_font (bold_font)
		end

	set_regular
		do
			set_font (regular_font)
		end

	set_monospaced
		do
			set_font (monospaced_font)
		end

	set_monospaced_bold
		do
			set_font (monospaced_bold_font)
		end

	set_font (a_font: EV_FONT)
			--
		deferred
		end

feature -- Drawing operations

	draw_mixed_style_text_top_left (x, y: INTEGER; a_mixed_text: INDEXABLE [EL_STYLED_ZSTRING, INTEGER])
		local
			l_x, i, l_upper, l_space_width: INTEGER
			i_th_text: EL_STYLED_ZSTRING
		do
			l_space_width := space_width
			l_upper := a_mixed_text.index_set.upper
			l_x := x
			from i := a_mixed_text.index_set.lower until i > l_upper loop
				i_th_text := a_mixed_text [i]
				i_th_text.change_font (Current)
				draw_text_top_left (l_x, y, i_th_text.to_unicode)
				l_x := l_x + i_th_text.width (Current)
				if i < l_upper then
					l_x := l_x + l_space_width
				end
				i := i + 1
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