note
	description: "Platform independent interface for drawable pixel buffer with Cairo drawing operations"
	notes: "[
		If `is_rgb_24_format' is True than a new cairo context is create each time `lock' is called
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 12:47:26 GMT (Friday 31st July 2020)"
	revision: "25"

deferred class
	EL_DRAWABLE_PIXEL_BUFFER_I

inherit
	EV_PIXEL_BUFFER_I
		rename
			draw_text as buffer_draw_text,
			draw_pixel_buffer as draw_pixel_buffer_at_rectangle,
			lock as lock_rgb_24,
			unlock as unlock_rgb_24,
			make_with_size as make_rgb_24_with_size,
			make_with_pixmap as make_rgb_24_with_pixmap,
			set_with_named_path as set_rgb_24_with_path,

			-- Measurement
			height as buffer_height,
			width as buffer_width
		redefine
			interface
		end

	EV_FONTABLE_I
		redefine
			interface
		end

	EL_ORIENTATION_ROUTINES

feature {EL_DRAWABLE_PIXEL_BUFFER} -- Initialization

	make_from_other (other: EL_DRAWABLE_PIXEL_BUFFER)
		do
			make_with_size (other.width, other.height)
			lock
			if is_locked then
				other.lock
				if other.is_locked then
					draw_pixel_buffer (0, 0, other)
					adjust_color_channels
					other.unlock
				end
				unlock
			end
		end

	make_mirrored (a_buffer: EL_DRAWABLE_PIXEL_BUFFER; axis: INTEGER)
			-- make alpha 32 bit format
		require
			valid_axis: is_valid_axis (axis)
		do
			make_with_size (a_buffer.width, a_buffer.height)
			a_buffer.lock
			if a_buffer.is_locked then
				inspect axis
					when X_axis then
						translate (0, a_buffer.height); scale (1, -1)
					when Y_axis then
						translate (a_buffer.width, 0); scale (-1, 1)
				else end
				draw_pixel_buffer (0, 0, a_buffer)
				a_buffer.unlock
			end
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			if is_rgb_24_format then
				make_rgb_24_with_pixmap (a_pixmap)
				adjust_color_channels
			else
				make_with_size (a_pixmap.width, a_pixmap.height)
				if attached cairo_context as c then
					c.draw_pixmap (0, 0, a_pixmap)
				end
			end
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; size: INTEGER; a_pixmap: EV_PIXMAP)
		local
			scaled: EL_RECTANGLE
		do
			create scaled.make_scaled_for_widget (dimension, a_pixmap, size)
			make_with_size (scaled.width, scaled.height)
			lock
			draw_scaled_pixmap (dimension, 0, 0, size, a_pixmap)
			if is_rgb_24_format then
				adjust_color_channels
			end
			unlock
		end

	make_with_size (a_width, a_height: INTEGER)
		do
			if is_rgb_24_format then
				make_rgb_24_with_size (a_width, a_height)
			else
				cairo_context := new_cairo (create {CAIRO_SURFACE_IMP}.make_argb_32 (a_width, a_height))
			end
		end

	make_with_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		require
			is_argb_32_format: is_argb_32_format
		do
			make_with_size (svg_image.width, svg_image.height)
			if not a_background_color.is_transparent then
				set_color (a_background_color)
				fill_rectangle (0, 0, width, height)
			end
			if attached cairo_context as c then
				c.set_surface_color_order
				svg_image.render (c)
			end
		end

feature -- Measurement

	height: INTEGER
		do
			if attached cairo_context as c then
				Result := c.height
			else
				Result := buffer_height
			end
		end

	width: INTEGER
		do
			if attached cairo_context as c then
				Result := c.width
			else
				Result := buffer_width
			end
		end

feature -- Access

	font: EV_FONT
		do
			if attached cairo_context as c then
				Result := c.font
			end
		end

feature -- Element change

	set_angle (angle: DOUBLE)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.rotate (angle)
			end
		end

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap)
			end
		end

	set_color (a_color: EV_COLOR)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.set_color (a_color)
			end
		end

	set_font (a_font: like font)
		require else
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.set_font (a_font)
			end
		end

	set_line_width (size: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.set_line_width (size)
			end
		end

	set_opacity (percentage: INTEGER)
		do
			if attached cairo_context as c then
				c.set_opacity (percentage)
			end
		end

	set_opaque
		do
			if attached cairo_context as c then
				c.set_opaque
			end
		end

	set_with_path (file_path: EL_FILE_PATH)
		do
			if is_rgb_24_format then
				cairo_context := Void
				set_rgb_24_with_path (file_path)
			else
				cairo_context := new_cairo (create {CAIRO_SURFACE_IMP}.make_from_file (file_path))
			end
		end

feature -- Basic operations

	draw_line (x1, y1, x2, y2: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_line (x1, y1, x2, y2)
			end
		end

	draw_pixel_buffer (x, y: INTEGER; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
--				c.draw_pixel_buffer (x, y, buffer)
			end
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_pixmap (x, y, a_pixmap)
			end
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_rectangle (x, y, a_width, a_height)
			end
		end

	draw_rotated_rectangle (rectangle: EV_RECTANGLE; a_angle: DOUBLE)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_rotated_rectangle (rectangle, a_angle)
			end
		end

	draw_rotated_text (rectangle: EL_TEXT_RECTANGLE; a_angle: DOUBLE)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_rotated_text (rectangle, a_angle)
			end
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_rotated_text_top_left (x, y, angle, a_text)
			end
		end

	draw_rounded_pixel_buffer (x, y, radius, corners_bitmap: INTEGER; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
--				c.draw_rounded_pixel_buffer (x, y, radius, corners_bitmap, buffer)
			end
		end

	draw_rounded_pixmap (x, y, radius, corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_rounded_pixmap (x, y, radius, corners_bitmap, a_pixmap)
			end
		end

	draw_scaled_pixel_buffer (dimension: NATURAL_8; x, y, a_size: INTEGER; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit and a_buffer.locked_for_rgb_24_bit
			valid_dimension: is_valid_dimension (dimension)
		do
			if attached cairo_context as c then
--				c.draw_scaled_pixel_buffer (dimension, x, y, a_size, a_buffer)
			end
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: INTEGER; a_pixmap: EV_PIXMAP)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_scaled_pixmap (dimension, x, y, a_size, a_pixmap)
			end
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_text (x, y, a_text)
			end
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.draw_text_top_left (x, y, a_text)
			end
		end

	fill_concave_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.fill_concave_corners (radius, corners_bitmap)
			end
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.fill_convex_corners (radius, corners_bitmap)
			end
		end

	fill_rectangle (x, y, a_width, a_height: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.fill_rectangle (x, y, a_width, a_height)
			end
		end

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			if is_rgb_24_format then
				save_to_named_path (file_path)
			elseif attached cairo_context as c then
				c.save_as (file_path)
			end
		end

feature -- Status query

	is_argb_32_format: BOOLEAN
		do
			Result := interface.format = 32
		end

	is_rgb_24_format: BOOLEAN
		do
			Result := interface.format = 24
		end

feature -- Transform

	flip (a_width, a_height: INTEGER; mirror_state: NATURAL_8)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.flip (a_width, a_height, mirror_state)
			end
		end

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.rotate (angle)
			end
		end

	rotate_quarter (n: INTEGER)
		-- rotate `n * 90' degrees
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.rotate_quarter (n)
			end
		end

	scale (x_factor, y_factor: DOUBLE)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.scale (x_factor, y_factor)
			end
		end

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.translate (x, y)
			end
		end

feature -- Status change

	lock
		require else
			unlocked: not is_locked
		do
			if is_rgb_24_format then
				cairo_context := new_cairo (create {CAIRO_SURFACE_IMP}.make_with_rgb_24_data (pixel_data, width, height))
			end
			lock_rgb_24
		end

	remove_clip
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.reset_clip
			end
		end

	restore
			-- restore last drawing setting state from state stack
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.restore
			end
		end

	save
			-- save current drawing setting state on to a stack
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.save
			end
		end

	set_antialias_best
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			if attached cairo_context as c then
				c.set_antialias_best
			end
		end

	unlock
		require else
			locked: is_locked
		do
			if is_locked then
				if is_rgb_24_format then
					cairo_context := Void
				end
				unlock_rgb_24
			end
		end

feature -- Contract Support

	locked_for_rgb_24_bit: BOOLEAN
		-- `False' if `format = Cairo_format_rgb24' and `not locked'
		do
			Result := is_rgb_24_format implies is_locked
		end

feature {EV_ANY, EV_ANY_I} -- Internal attributes

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	adjust_color_channels
		deferred
		end

	new_cairo (surface: CAIRO_SURFACE_I): CAIRO_PANGO_CONTEXT_I
		-- new cairo context
		do
			create {CAIRO_PANGO_CONTEXT_IMP} Result.make (surface)
		end

feature {NONE} -- Deferred implementation

	pixel_data: POINTER
		-- make sure to call `unlock' after accessing this on Windows
		deferred
		end

feature {CAIRO_DRAWABLE_CONTEXT_I} -- Internal attributes

	cairo_context: detachable CAIRO_PANGO_CONTEXT_I

end
