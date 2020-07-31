note
	description: "[
		Pixel buffer drawing using the [https://cairographics.org/ Cairo] and [http://www.pango.org/ Pangocairo]
		graphics libraries.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 16:03:04 GMT (Friday 31st July 2020)"
	revision: "2"

deferred class
	EL_PIXEL_BUFFER_I

inherit
	EV_FONTABLE_I
		export
			{NONE} all
		redefine
			interface
		end

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		undefine
			default_create, copy, out
		end

feature {EL_PIXEL_BUFFER} -- Initialization

	make_with_scaled_pixmap (dimension: NATURAL_8; size: INTEGER; pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			scaled: EL_RECTANGLE
		do
			create scaled.make_scaled_for_widget (dimension, pixmap, size)
			make_with_size (scaled.width, scaled.height)
			draw_scaled_pixmap (dimension, 0, 0, size, pixmap)
		end

	make_with_size (a_width, a_height: INTEGER)
			-- Create with size.
		require
			width_valid: a_width > 0
			height_valid: a_height > 0
		do
			cairo := new_cairo (create {CAIRO_SURFACE_IMP}.make_argb_32 (a_width, a_height))
		end

feature -- Access

	font: EV_FONT
		do
			Result := cairo.font
		end

feature -- Measurement

	height: INTEGER
			-- Height
		do
			Result := cairo.height
		end

	width: INTEGER
			-- Width
		do
			Result := cairo.width
		end

feature -- Element change

	set_angle (angle: DOUBLE)
		do
			cairo.rotate (angle)
		end

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			cairo.set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap)
		end

	set_color (a_color: EV_COLOR)
		do
			cairo.set_color (a_color)
		end

	set_font (a_font: like font)
		do
			cairo.set_font (a_font)
		end

	set_line_width (size: INTEGER)
		do
			cairo.set_line_width (size)
		end

	set_opacity (percentage: INTEGER)
		do
			cairo.set_opacity (percentage)
		end

	set_opaque
		do
			cairo.set_opaque
		end

	set_with_path (image_path: EL_FILE_PATH)
		require
			image_exists: image_path.exists
		do
			cairo := new_cairo (create {CAIRO_SURFACE_IMP}.make_from_file (image_path))
		end

feature -- Drawing operations

	draw_line (x1, y1, x2, y2: INTEGER)
		do
			cairo.draw_line (x1, y1, x2, y2)
		end

	draw_pixel_buffer (x, y: INTEGER; buffer: EL_PIXEL_BUFFER)
		do
			cairo.draw_pixel_buf (x, y, buffer)
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		do
			cairo.draw_pixmap (x, y, a_pixmap)
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		do
			cairo.draw_rectangle (x, y, a_width, a_height)
		end

	draw_rotated_rectangle (rectangle: EV_RECTANGLE; a_angle: DOUBLE)
		do
			cairo.draw_rotated_rectangle (rectangle, a_angle)
		end

	draw_rotated_text (rectangle: EL_TEXT_RECTANGLE; a_angle: DOUBLE)
		do
			cairo.draw_rotated_text (rectangle, a_angle)
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		do
			cairo.draw_rotated_text_top_left (x, y, angle, a_text)
		end

	draw_rounded_pixel_buffer (x, y, radius, corners_bitmap: INTEGER; buffer: EL_PIXEL_BUFFER)
		do
			cairo.draw_rounded_pixel_buf (x, y, radius, corners_bitmap, buffer)
		end

	draw_rounded_pixmap (x, y, radius, corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		do
			cairo.draw_rounded_pixmap (x, y, radius, corners_bitmap, a_pixmap)
		end

	draw_scaled_pixel_buffer (dimension: NATURAL_8; x, y, size: INTEGER; buffer: EL_PIXEL_BUFFER)
		do
			cairo.draw_scaled_pixel_buf (dimension, x, y, size, buffer)
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, size: INTEGER; pixmap: EV_PIXMAP)
		do
			cairo.draw_scaled_pixmap (dimension, x, y, size, pixmap)
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			cairo.draw_text (x, y, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			cairo.draw_text_top_left (x, y, a_text)
		end

	fill_concave_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		do
			cairo.fill_concave_corners (radius, corners_bitmap)
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		do
			cairo.fill_convex_corners (radius, corners_bitmap)
		end

	fill_rectangle (x, y, a_width, a_height: INTEGER)
		do
			cairo.fill_rectangle (x, y, a_width, a_height)
		end

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			cairo.save_as (file_path)
		end

feature -- Transform

	flip (a_width, a_height: INTEGER; mirror_state: NATURAL_8)
		do
			cairo.flip (a_width, a_height, mirror_state)
		end

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		do
			cairo.rotate (angle)
		end

	rotate_quarter (n: INTEGER)
		-- rotate `n * 90' degrees
		do
			cairo.rotate_quarter (n)
		end

	scale (x_factor, y_factor: DOUBLE)
		do
			cairo.scale (x_factor, y_factor)
		end

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		do
			cairo.translate (x, y)
		end

feature -- Status change

	remove_clip
		do
			cairo.reset_clip
		end

	restore
			-- restore last drawing setting state from state stack
		do
			cairo.restore
		end

	save
			-- save current drawing setting state on to a stack
		do
			cairo.save
		end

	set_antialias_best
		do
			cairo.set_antialias_best
		end

feature {EV_ANY_I} -- Implementation

	new_cairo (surface: CAIRO_SURFACE_I): CAIRO_PANGO_CONTEXT_I
		-- new cairo context
		do
			create {CAIRO_PANGO_CONTEXT_IMP} Result.make (surface)
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	cairo: CAIRO_PANGO_CONTEXT_I

	interface: detachable EL_PIXEL_BUFFER note option: stable attribute end;
		-- Interface object for `Current'.

end
