note
	description: "Cairo-Pango text layout"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 14:44:13 GMT (Monday 3rd August 2020)"
	revision: "1"

deferred class
	CAIRO_TEXT_LAYOUT_I

inherit
	EL_OWNED_C_OBJECT
		export
			{CAIRO_DRAWABLE_CONTEXT_I} self_ptr
		end

	EL_MODULE_STRING_32

	EL_SHARED_ONCE_STRING_32

	CAIRO_SHARED_GOBJECT_API

	CAIRO_SHARED_PANGO_CAIRO_API

	CAIRO_SHARED_PANGO_API

feature {NONE} -- Initialization

	make (drawable: CAIRO_DRAWABLE_CONTEXT_I)
		do
			create font
			make_from_pointer (Pango_cairo.new_layout (drawable.context))
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
			font.copy (a_font)
			check_font_availability
			set_pango_font (font)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		local
			text_utf_8: STRING; l_text: STRING_32
		do
			l_text := once_copy_general_32 (a_text)
			text_utf_8 := String_32.to_utf_8 (l_text, False)
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

	check_font_availability
		deferred
		end

	set_pango_font (a_font: CAIRO_PANGO_FONT)
		do
			Pango.set_layout_font_description (self_ptr, a_font.item)
		end

end
