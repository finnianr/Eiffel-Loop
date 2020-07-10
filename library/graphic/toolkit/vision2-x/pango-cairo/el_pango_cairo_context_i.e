note
	description: "Platform independent interface for Pango-Cairo drawing context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-08 17:52:21 GMT (Wednesday 8th July 2020)"
	revision: "1"

deferred class
	EL_PANGO_CAIRO_CONTEXT_I

inherit
	EL_OWNED_C_OBJECT
		export
			{EL_DRAWABLE_PIXEL_BUFFER_I, EL_SVG_IMAGE, EL_DRAWABLE_CAIRO_CONTEXT} self_ptr
		end

	EL_DRAWABLE_CAIRO_CONTEXT
		rename
			context as self_ptr
		end

	EL_MODULE_ZSTRING

	EL_SHARED_GOBJECT_API

	EL_SHARED_ONCE_STRING_8

	EL_SHARED_PANGO_API

	EL_SHARED_PANGO_CAIRO_API

feature {NONE} -- Initialization

	make_argb_32 (a_width, a_height: INTEGER)
		do
			make_with_surface (Cairo.new_image_surface (Cairo_format_ARGB_32, a_width, a_height))
		end

	make_default
		do
			create color
			create font
			set_opaque
		end

	make_from_file (file_path: EL_FILE_PATH)
		require
			exists: file_path.exists
		local
			cairo_file: EL_PNG_IMAGE_FILE
		do
			make_default
			if file_path.exists then
				create cairo_file.make_open_read (file_path)
				make_with_surface (cairo_file.read_cairo_surface)
				cairo_file.close
			end
		ensure
			initialized: is_attached (self_ptr)
		end

	make_rgb_24 (a_width, a_height: INTEGER)
		do
			make_with_surface (Cairo.new_image_surface (Cairo_format_RGB_24, a_width, a_height))
		end

	make_with_argb_32_data (pixel_data: POINTER; a_width, a_height: INTEGER)
		do
			make_with_data (pixel_data, Cairo_format_ARGB_32, a_width, a_height)
		end

	make_with_data (pixel_data: POINTER; format, a_width, a_height: INTEGER)
		require
			valid_format: format = Cairo_format_ARGB_32 or format = Cairo_format_RGB_24
		local
			stride: INTEGER
		do
			stride := Cairo.format_stride_for_width (format, a_width)
			make_with_surface (Cairo.new_image_surface_for_data (pixel_data, format, a_width, a_height, stride))
		end

	make_with_rgb_24_data (pixel_data: POINTER; a_width, a_height: INTEGER)
		do
			make_with_data (pixel_data, Cairo_format_RGB_24, a_width, a_height)
		end

	make_with_surface (a_surface: POINTER)
		do
			make_default
			surface := a_surface
			if is_attached (a_surface) then
				make_from_pointer (Cairo.new_cairo (a_surface))
			end
		end

feature -- Access

	color: EV_COLOR

	font: EV_FONT

feature -- Measurement

	height: INTEGER
		do
			Result := Cairo.surface_height (surface)
		end

	width: INTEGER
		do
			Result := Cairo.surface_width (surface)
		end

feature -- Status change

	set_surface_color_order
		-- set color channel order (needed for Unix)
		deferred
		end

feature -- Element change

	set_color (a_color: like color)
		do
			color := a_color
			set_source_color
		end

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

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		local
			file_out: EL_PNG_IMAGE_FILE
		do
			create file_out.make_open_write (file_path)
			file_out.put_image (surface)
			file_out.close
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
				draw_text_top_left (line.x - rectangle.x, line.y - rectangle.y, line.text.to_unicode)
			end
			restore
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		local
			text_rect: EL_RECTANGLE; text_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER
			l_x, l_y, hyphen_width: INTEGER
		do
			create text_rect.make_for_text (a_text, font)
			create text_pixel_buffer.make_with_size (32, text_rect.width, text_rect.height)

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
			pango_font: EL_PANGO_FONT
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
			Cairo.destroy (self_ptr); Cairo.destroy_surface (surface)
		end

	check_font_availability
		deferred
		end

	draw_layout_text
		do
			Pango_cairo.update_layout (self_ptr, pango_layout)
			Pango_cairo.show_layout (self_ptr, pango_layout)
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
				Result := Pango_cairo.create_layout (self_ptr)
				internal_pango_layout := Result
			end
		end

	restore_color
		do
			set_color (color)
		end

	set_layout_text_font (pango_font: EL_PANGO_FONT)
		do
			Pango.set_layout_font_description (pango_layout, pango_font.item)
		end

	set_source_color
		deferred
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I, EL_DRAWABLE_CAIRO_CONTEXT} -- Internal attributes

	internal_pango_layout: POINTER

	surface: POINTER

end
