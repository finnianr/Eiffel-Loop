note
	description: "Platform independent interface for Pango-Cairo drawing context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 8:51:04 GMT (Saturday 1st August 2020)"
	revision: "7"

deferred class
	CAIRO_PANGO_CONTEXT_I

inherit
	CAIRO_DRAWABLE_CONTEXT_I
		redefine
			make, c_free
		end

	EL_MODULE_ZSTRING

	CAIRO_SHARED_GOBJECT_API

	EL_SHARED_ONCE_STRING_8

	CAIRO_SHARED_PANGO_API

	CAIRO_SHARED_PANGO_CAIRO_API

feature {NONE} -- Initialization

	make (a_surface: CAIRO_SURFACE_I)
		do
			create font
			Precursor (a_surface)
		end

feature -- Access

	font: EV_FONT

feature -- Element change

	set_font (a_font: like font)
		do
			font := a_font.twin
			check_font_availability
			set_layout_text_font (font)
		end

	set_layout_text (a_text: READABLE_STRING_GENERAL)
		local
			utf8_text: STRING; l_text: READABLE_STRING_GENERAL
			c: EL_UTF_CONVERTER
		do
			l_text := Zstring.to_unicode_general (a_text)
			utf8_text := empty_once_string_8
			c.utf_32_string_into_utf_8_string_8 (l_text, utf8_text)
			Pango.set_layout_text (pango_layout, utf8_text.area.base_address, utf8_text.count)
			adjust_pango_font (font.string_width (l_text))
		end

feature -- Text drawing

	draw_rotated_text (rectangle: EL_TEXT_RECTANGLE; a_angle: DOUBLE)
		local
			line: EL_ALIGNED_TEXT
		do
			save
			translate (rectangle.x, rectangle.y)
			rotate (a_angle)
			set_antialias_best
			across rectangle.internal_lines as list loop
				line := list.item
				set_font (line.font)
				line.align (rectangle)
				draw_text_top_left (line.x - rectangle.x, line.y - rectangle.y, line.text)
			end
			restore
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		local
			text_rect: EL_RECTANGLE; text_pixel_buffer: EL_PIXEL_BUFFER
			l_x, l_y, hyphen_width: INTEGER
		do
			create text_rect.make_for_text (a_text, font)
			create text_pixel_buffer.make_with_size (text_rect.width, text_rect.height)

			text_pixel_buffer.set_color (color.twin)
			text_pixel_buffer.set_antialias_best
			text_pixel_buffer.set_font (font)
			text_pixel_buffer.draw_text_top_left (0, 0, a_text)

			-- Make last hyphen more prominent
			if a_text [a_text.count] = '-' then
				l_x := font.string_width (a_text.substring (1, a_text.count - 1))
				l_y := font.ascent - font.descent + 1
				hyphen_width := font.string_width (once "-") - 1
				text_pixel_buffer.set_line_width (1)
				text_pixel_buffer.draw_line (l_x + 1, l_y, l_x + hyphen_width, l_y)
			end

			save
			translate (x, y); rotate (angle)
			draw_pixel_buffer (0, 0, text_pixel_buffer)
			restore
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			draw_text_top_left (x, y - font.ascent, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		local
			actual_width, required_width: INTEGER
			l_text: READABLE_STRING_GENERAL
		do
			set_antialias_best
			move_to (x, y)
			l_text := Zstring.to_unicode_general (a_text)
			set_layout_text (l_text)

			-- horizontal scaling to fit required width
			actual_width := text_width; required_width := font.string_width (l_text)

			draw_layout_text
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I} -- Implementation

	adjust_pango_font (required_width: INTEGER)
		local
			actual_width, adjustment, signed_adjustment, limit: INTEGER
			pango_font: CAIRO_PANGO_FONT
		do
			actual_width := text_width
			if actual_width /= required_width then
				pango_font := font
				pango_font.scale (required_width / actual_width)
				set_layout_text_font (pango_font)

				-- Finetune the font height to make actual_width = required_width
				from
					actual_width := text_width
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
					set_layout_text_font (pango_font)
					actual_width := text_width
					adjustment := adjustment // 2
				end
			end
		end

	c_free (this: POINTER)
			--
		do
			if is_attached (internal_pango_layout) then
				Gobject.object_unref (internal_pango_layout)
			end
			Precursor (this)
		end

	check_font_availability
		deferred
		end

	draw_layout_text
		do
			Pango_cairo.update_layout (context, pango_layout)
			Pango_cairo.show_layout (context, pango_layout)
		end

	text_height: INTEGER
		do
			Result := Pango.layout_size (pango_layout).height
		end

	text_width: INTEGER
		do
			Result := Pango.layout_size (pango_layout).width
		end

	pango_layout: POINTER
		do
			Result := internal_pango_layout
			if not is_attached (Result) then
				Result := Pango_cairo.new_layout (context)
				internal_pango_layout := Result
			end
		end

	set_layout_text_font (pango_font: CAIRO_PANGO_FONT)
		do
			Pango.set_layout_font_description (pango_layout, pango_font.item)
		end

feature {NONE} -- Internal attributes

	internal_pango_layout: POINTER

end
