note
	description: "Summary description for {EL_DRAWABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:19:13 GMT (Saturday 26th December 2015)"
	revision: "1"

deferred class
	EL_DRAWABLE

inherit
	EL_MODULE_GUI

feature -- Drawing operations

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
			draw_text_top_left (x, y, a_text)
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
			set_foreground_color (GUI.White)
			set_line_width (1)
			draw_segment (x, y, x, y1)
			draw_segment (x, y, x1, y)

			set_line_width (1)
			set_foreground_color (GUI.Gray)
			draw_segment (x1, y + 1, x1, y1 - 1)
			draw_segment (x + 1, y1, x1 - 1, y1)

			set_foreground_color (GUI.Dark_gray)
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

	draw_centered_text (a_text: READABLE_STRING_GENERAL; rect: EL_RECTANGLE)
		local
			centered_rect: EL_RECTANGLE
		do
			create centered_rect.make_for_text (a_text, font)
			centered_rect.move_center (rect)
			centered_rect.set_y (centered_rect.y - font.descent // 2)

			draw_text_top_left (centered_rect.x, centered_rect.y, a_text)
		end

	draw_pixel_buffer (x, y: INTEGER; a_pixels: EV_PIXEL_BUFFER)
		do
			draw_sub_pixel_buffer (x, y, a_pixels, create {EV_RECTANGLE}.make (0, 0, a_pixels.width, a_pixels.height))
		end

--feature -- Duplication

--	sub_drawable_pixel_buffer (area: EV_RECTANGLE): EL_DRAWABLE_PIXEL_BUFFER
--			-- Return a pixmap region of `Current' represented by rectangle `area'
--		do
--			create Result.make_with_pixmap (sub_pixmap (area))
--		end

feature -- Element change

	set_foreground_color (a_color: EV_COLOR)
			--
		deferred
		end

	set_background_color (a_color: EV_COLOR)
			--
		deferred
		end

	set_line_width (a_width: INTEGER)
			--
		deferred
		end

	set_font (a_font: EV_FONT)
			--
		deferred
		end

feature -- Status query

	has_saved_colors: BOOLEAN
		do
			Result := Color_stack.count >= 2
		end

feature -- Measurement

	width: INTEGER
		deferred
		end

	height: INTEGER
		deferred
		end

feature -- Access

	font: EV_FONT
		deferred
		end

	foreground_color: EV_COLOR
		deferred
		end

	background_color: EV_COLOR
		deferred
		end

feature -- Basic operations

	save_colors
		do
			Color_stack.put (foreground_color.twin)
			Color_stack.put (background_color.twin)
		end

	restore_colors
		require
			has_saved_colors: has_saved_colors
		do
			set_background_color (Color_stack.item)
			Color_stack.remove
			set_foreground_color (Color_stack.item)
			Color_stack.remove
		end

feature -- EV_DRAWABLE routines

	clear
		deferred
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		deferred
		end

	draw_rotated_text (x, y: INTEGER; angle: REAL; a_text: ZSTRING)
			-- Draw rotated text `a_text' with left of baseline at (`x', `y') using `font'.
			-- Rotation is number of radians counter-clockwise from horizontal plane.
		do
			if attached {EV_DRAWABLE_IMP} implementation as imp then
				imp.draw_rotated_text (x, y, angle, a_text)
			end
		end

	draw_segment (x1, y1, x2, y2: INTEGER)
			--
		deferred
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		deferred
		end

	draw_polyline (points: ARRAY [EV_COORDINATE]; is_closed: BOOLEAN)
		deferred
		end

	draw_sub_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; area: EV_RECTANGLE)
		deferred
		end

	draw_sub_pixel_buffer (x, y: INTEGER; a_pixmap: EV_PIXEL_BUFFER; area: EV_RECTANGLE)
		deferred
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		deferred
		end

	fill_rectangle (x, y, a_width, a_height: INTEGER)
			--
		deferred
		end

	redraw
		deferred
		end

	sub_pixmap (area: EV_RECTANGLE): EV_PIXMAP
		deferred
		end

feature {NONE} -- Implementation

	implementation: EV_DRAWABLE_I
		deferred
		end

feature {NONE} -- Constants

	Color_stack: ARRAYED_STACK [EV_COLOR]
		once
			create Result.make (2)
		end

end