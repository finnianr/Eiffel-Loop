note
	description: "Pango-Cairo drawing context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 15:12:16 GMT (Monday 3rd August 2020)"
	revision: "10"

deferred class
	CAIRO_DRAWING_CONTEXT_I

inherit
	CAIRO_DRAWABLE_CONTEXT_I

	CAIRO_SHARED_PANGO_CAIRO_API

	EL_LAZY_ATTRIBUTE
		rename
			object as text_layout,
			new_object as new_text_layout
		end

feature {NONE} -- Initialization

	make (a_surface: CAIRO_SURFACE_I)
		do
			create color
			set_opaque
			surface := a_surface
			if a_surface.is_initialized then
				make_from_pointer (Cairo.new_cairo (a_surface.self_ptr))
			end
		end

	make_with_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		do
			make (create {CAIRO_SURFACE_IMP}.make_argb_32 (svg_image.width, svg_image.height))
			if not a_background_color.is_transparent then
				set_color (a_background_color)
				fill_rectangle (0, 0, width, height)
			end
			svg_image.render (Current)
		end

feature -- Properties

	color: EV_COLOR

	font: EV_FONT
		do
			Result := text_layout.font
		end

	opacity: INTEGER
		-- percentage opacity. 100 is totally opaque

feature -- Property change

	set_color (a_color: like color)
		do
			color := a_color
			set_source_color
		end

	set_font (a_font: like font)
		do
			text_layout.set_font (a_font)
		end

	set_opacity (percentage: INTEGER)
		require
			is_percent: 0 <= percentage and percentage <= 100
		do
			opacity := percentage
		end

	set_opaque
		do
			opacity := 100
		end

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			surface.save_as (file_path)
		end

	show_text (a_text: READABLE_STRING_GENERAL)
		do
			text_layout.set_text (a_text)
			Pango_cairo.update_layout (context, text_layout.self_ptr)
			Pango_cairo.show_layout (context, text_layout.self_ptr)
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
			text_rect: EL_RECTANGLE; text_area: CAIRO_DRAWING_AREA
			l_x, l_y, hyphen_width: INTEGER
		do
			create text_rect.make_for_text (a_text, font)
			create text_area.make_with_rectangle (text_rect)

			text_area.set_color (color.twin)
			text_area.set_font (font)
			text_area.draw_text_top_left (0, 0, a_text)

			-- Make last hyphen more prominent
			if a_text [a_text.count] = '-' then
				l_x := font.string_width (a_text.substring (1, a_text.count - 1))
				l_y := font.ascent - font.descent + 1
				hyphen_width := font.string_width (once "-") - 1
				text_area.set_line_width (1)
				text_area.draw_line (l_x + 1, l_y, l_x + hyphen_width, l_y)
			end

			save
			translate (x, y); rotate (angle)
			draw_drawing_area (0, 0, text_area)
			restore
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			draw_text_top_left (x, y - font.ascent, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			set_antialias_best
			move_to (x, y)
			show_text (a_text)
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
			--
		do
			Cairo.destroy (this)
		end

	new_text_layout: CAIRO_TEXT_LAYOUT_I
		do
			create {CAIRO_TEXT_LAYOUT_IMP} Result.make (Current)
		end

	restore_color
		do
			set_color (color)
		end

end
