note
	description: "Cairo-Pango text layout"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 14:43:58 GMT (Monday 30th May 2022)"
	revision: "5"

deferred class
	CAIRO_TEXT_LAYOUT_I

inherit
	EL_OWNED_C_OBJECT
		export
			{CAIRO_DRAWABLE_CONTEXT_I} self_ptr
		end

	EL_MODULE_BUFFER_32

	CAIRO_SHARED_GOBJECT_API

	CAIRO_SHARED_PANGO_LAYOUT_API

	CAIRO_SHARED_PANGO_API

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
			text_utf_8: STRING; l_text: STRING_32; s: EL_STRING_32_ROUTINES
		do
			l_text := buffer_32.copied_general (a_text)
			text_utf_8 := s.to_utf_8 (l_text, False)
			Pango.set_layout_text (self_ptr, text_utf_8.area.base_address, text_utf_8.count)
			adjust_pango_font (font.string_width (l_text))
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

	c_free (this: POINTER)
		--
		do
			Gobject.object_unref (this)
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