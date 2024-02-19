note
	description: "Drawable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-14 10:31:45 GMT (Wednesday 14th February 2024)"
	revision: "19"

deferred class
	EL_DRAWABLE

inherit
	EV_DRAWABLE
		redefine
			implementation, draw_text, draw_text_top_left, draw_ellipsed_text, draw_ellipsed_text_top_left,
			draw_sub_pixel_buffer
		end

	EL_MODULE_ACTION; EL_MODULE_COLOR

	EL_RECTANGULAR

	EL_STRING_GENERAL_ROUTINES

feature -- Drawing operations

	draw_centered_text (a_text: READABLE_STRING_GENERAL; rectangle: EL_RECTANGLE)
		-- draw `a_text' centered in `rectangle'
		do
			if attached rectangle.centered_text (rectangle, a_text, font) as rect then
				draw_text_top_left (rect.x, rect.y, a_text)
			end
		end

	draw_pixel_buffer (x, y: INTEGER; a_pixels: EV_PIXEL_BUFFER)
		do
			draw_sub_pixel_buffer (x, y, a_pixels, a_pixels.area)
		end

	draw_raised_rectangle (x, y, a_width, a_height: INTEGER; a_color: EV_COLOR)
			--
		do
			save_colors
			set_foreground_color (a_color)
			fill_rectangle (x, y, a_width, a_height)
			draw_rectangle_shadows (x, y, a_width, a_height)
			restore_colors
		end

	draw_rectangle_shadows (x, y, a_width, a_height: INTEGER)
			--
		local
			x1, y1: INTEGER
		do
			x1 := x + a_width - 1
			y1 := y + a_height - 1

			save_colors
			set_foreground_color (Color.White)
			set_line_width (1)
			draw_segment (x, y, x, y1)
			draw_segment (x, y, x1, y)

			set_line_width (1)
			set_foreground_color (Color.Gray)
			draw_segment (x1, y + 1, x1, y1 - 1)
			draw_segment (x + 1, y1, x1 - 1, y1)

			set_foreground_color (Color.Dark_gray)
			draw_segment (x1 - 1, y + 1, x1 - 1, y1 - 1)
			draw_segment (x + 1, y1 - 1, x1 - 1, y1 - 1)
			restore_colors
		end

	draw_row_of_tiles (r: EV_RECTANGLE; tile_pixmap: EV_PIXMAP)
			--
		local
			tile_left_x: INTEGER; tile_area: EV_RECTANGLE
		do
			from tile_left_x := r.x until tile_left_x > r.width loop
				create tile_area.make (0, 0, tile_pixmap.width.min (width - tile_left_x), r.height)
				draw_sub_pixmap (tile_left_x, r.y, tile_pixmap, tile_area)
				tile_left_x := tile_left_x + tile_pixmap.width
			end
		end

	draw_shadowed_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; a_shadow_color: EV_COLOR)
		local
			l_color: EV_COLOR
			offset: INTEGER
		do
			offset := (font.width * 0.08).rounded.min (1)
			l_color := foreground_color.twin

			set_foreground_color (a_shadow_color)
			draw_text_top_left (x + offset, y + offset, a_text)

			set_foreground_color (l_color)
			draw_text_top_left (x, y, to_unicode_general (a_text))
		end

	draw_sub_pixel_buffer (x, y: INTEGER; a_pixel_buffer: EV_PIXEL_BUFFER; area: EV_RECTANGLE)
		do
			implementation.draw_sub_pixel_buffer (x, y, a_pixel_buffer, area)
		end

feature -- Status query

	has_saved_colors: BOOLEAN
		do
			Result := Color_stack.count >= 2
		end

feature -- Basic operations

	restore_colors
		require
			has_saved_colors: has_saved_colors
		do
			set_background_color (Color_stack.item)
			Color_stack.remove
			set_foreground_color (Color_stack.item)
			Color_stack.remove
		end

	save_colors
		do
			Color_stack.put (foreground_color.twin)
			Color_stack.put (background_color.twin)
		end

feature -- Drawing operations

	draw_ellipsed_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; clipping_width: INTEGER)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
			implementation.draw_ellipsed_text (x, y, to_unicode_general (a_text), clipping_width)
		end

	draw_ellipsed_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL; clipping_width: INTEGER)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
			-- Text is clipped to `clipping_width' in pixels and ellipses are displayed
			-- to show truncated characters if any.
		do
			implementation.draw_ellipsed_text_top_left (x, y, to_unicode_general (a_text), clipping_width)
		end

	draw_rotated_text (x, y: INTEGER; angle: REAL; a_text: READABLE_STRING_GENERAL)
			-- Draw rotated text `a_text' with left of baseline at (`x', `y') using `font'.
			-- Rotation is number of radians counter-clockwise from horizontal plane.
		do
			if attached {EV_DRAWABLE_IMP} implementation as imp then
				imp.draw_rotated_text (x, y, angle, to_unicode_general (a_text))
			end
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
		do
			implementation.draw_text (x, y, to_unicode_general (a_text))
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		do
			implementation.draw_text_top_left (x, y, to_unicode_general (a_text))
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	implementation: EV_DRAWABLE_I

feature {NONE} -- Constants

	Color_stack: ARRAYED_STACK [EV_COLOR]
		once
			create Result.make (2)
		end

end