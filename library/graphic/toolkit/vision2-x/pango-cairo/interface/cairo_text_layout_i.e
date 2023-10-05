note
	description: "Cairo-Pango text layout"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	CAIRO_TEXT_LAYOUT_I

inherit
	CAIRO_OWNED_G_OBJECT

	CAIRO_SHARED_PANGO_LAYOUT_API

	CAIRO_SHARED_PANGO_API

	EL_SHARED_UTF_8_STRING

feature {NONE} -- Initialization

	make (drawable: CAIRO_DRAWABLE_CONTEXT_I)
		do
			create font
			make_from_pointer (Pango_layout.new (drawable.context))
		end

feature -- Access

	font: EV_FONT

feature -- Measurement

	height: INTEGER
		do
			Result := Pango.layout_size (self_ptr).height
		end

	width: INTEGER
		do
			Result := Pango.layout_size (self_ptr).width
		end

	unknown_glyphs_count: INTEGER

feature -- Element change

	set_font (a_font: like font)
		do
			-- Need to make a copy because `font.preferred_families' is modified by `preferred_families'
			font := a_font.twin
--			`font.copy (a_font)' has a bug on Windows, ES version 16.05.9
			update_preferred_families
			set_pango_font (a_font)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		local
			c_text: ANY
		do
			if attached UTF_8_string as text_utf_8 then
				text_utf_8.set_from_general (a_text)
				c_text := text_utf_8.to_c
				Pango.set_layout_text (self_ptr, $c_text, text_utf_8.count)
				unknown_glyphs_count := Pango.layout_unknown_glyphs_count (self_ptr)
			end
			adjust_pango_font (font.string_width (a_text))
		ensure
			all_gylphs_renderable: unknown_glyphs_count = 0
		end

feature {NONE} -- Implementation

	adjust_pango_font (required_width: INTEGER)
		local
			actual_width, adjustment, signed_adjustment, limit: INTEGER
			pango_font: CAIRO_PANGO_FONT
		do
			actual_width := width
			if actual_width /= required_width then
				pango_font := font
				pango_font.scale (required_width / actual_width)
				set_pango_font (pango_font)

				-- Finetune the font height to make actual_width = required_width
				from
					actual_width := width
					adjustment := pango_font.height // 100; limit := adjustment // 4
				until
					actual_width = required_width or else adjustment < limit
				loop
					if actual_width < required_width then
						signed_adjustment := adjustment
					else
						signed_adjustment := adjustment.opposite
					end
					pango_font.set_height (pango_font.height + signed_adjustment)
					set_pango_font (pango_font)
					actual_width := width
					adjustment := adjustment // 2
				end
			end
		end

	update_preferred_families
		-- update `preferred_families' for platform
		deferred
		end

	set_pango_font (a_font: CAIRO_PANGO_FONT)
		do
			Pango.set_layout_font_description (self_ptr, a_font.item)
		end

end
