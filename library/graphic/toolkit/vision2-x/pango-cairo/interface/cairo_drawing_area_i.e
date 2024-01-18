note
	description: "Cross-platform interface for ${CAIRO_DRAWING_AREA}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	CAIRO_DRAWING_AREA_I

inherit
	EV_FONTABLE_I
		export
			{NONE} all
		redefine
			interface
		end

	EL_MODULE_ORIENTATION

feature {CAIRO_DRAWING_AREA} -- Initialization

	make
			-- Initialize `Current'.
		do
			set_is_initialized (True)
		end

	make_cairo_context (a_surface: CAIRO_SURFACE_I)
		deferred
		end

	make_with_path (image_path: FILE_PATH)
		-- make from an image file
		require
			path_exists: image_path.exists
		local
			buffer: CAIRO_PIXEL_BUFFER
		do
			create buffer.make (image_path)
			if buffer.is_initialized then
				make_with_size (buffer.width, buffer.height)
				if attached surface.new_context as context then
					context.draw_pixel_buffer (0, 0, buffer)
				end
			else
				make_with_size (1, 1)
			end
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			make_with_size (a_pixmap.width, a_pixmap.height)
			draw_pixmap (0, 0, a_pixmap)
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; size: INTEGER; pixmap: EV_PIXMAP)
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
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
			make_cairo_context (create {CAIRO_SURFACE_IMP}.make_argb_32 (a_width, a_height))
		end

	make_with_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		deferred
		end

	old_make (an_interface: CAIRO_DRAWING_AREA)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature -- Access

	font: EV_FONT
		deferred
		end

feature -- Measurement

	height: INTEGER
			-- Height
		deferred
		end

	width: INTEGER
			-- Width
		deferred
		end

feature -- Conversion

	to_buffer: EV_PIXEL_BUFFER
		-- Vision-2 pixel buffer
		deferred
		end

	to_surface: CAIRO_PIXEL_SURFACE_I
		-- to cairo pixel surface
		-- don't forget to call destroy on result for Windows
		do
			create {CAIRO_PIXEL_SURFACE_IMP} Result.make_with_size (width, height)
			Result.new_context.draw_surface (0, 0, surface)
			Result.adjust_colors
		end

feature -- Element change

	set_angle (angle: DOUBLE)
		deferred
		end

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius: DOUBLE; corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		deferred
		end

	set_color (a_color: EV_COLOR)
		deferred
		end

	set_font (a_font: like font)
		deferred
		end

	set_line_width (size: INTEGER)
		deferred
		end

	set_opacity (percentage: INTEGER)
		deferred
		end

	set_opaque
		deferred
		end

	set_with_png (png_path: FILE_PATH)
		require
			image_exists: png_path.exists
		do
			make_cairo_context (create {CAIRO_SURFACE_IMP}.make_from_png (png_path))
		end

feature -- Basic operations

	save_as (file_path: FILE_PATH)
			-- Save as png file
		deferred
		end

feature -- Drawing operations

	draw_area (x, y: DOUBLE; drawing: CAIRO_DRAWING_AREA)
		deferred
		end

	draw_line (x1, y1, x2, y2: INTEGER)
		deferred
		end

	draw_pixmap (x, y: DOUBLE; pixmap: EV_PIXMAP)
		deferred
		end

	draw_rectangle (x, y, a_width, a_height: DOUBLE)
		deferred
		end

	draw_rotated_rectangle (rectangle: EV_RECTANGLE; a_angle: DOUBLE)
		deferred
		end

	draw_rotated_text (rectangle: EL_TEXT_RECTANGLE; a_angle: DOUBLE)
		deferred
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		deferred
		end

	draw_rounded_area (x, y, radius: DOUBLE; corners_bitmap: INTEGER; drawing: CAIRO_DRAWING_AREA)
		deferred
		end

	draw_rounded_pixmap (x, y, radius: DOUBLE; corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		deferred
		end

	draw_scaled_area (dimension: NATURAL_8; x, y, size: DOUBLE; other: CAIRO_DRAWING_AREA)
		deferred
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EV_PIXMAP)
		deferred
		end

	draw_scaled_surface (dimension: NATURAL_8; x, y, size: DOUBLE; a_surface: CAIRO_SURFACE_I)
		deferred
		end

	draw_surface (x, y: DOUBLE; source: CAIRO_SURFACE_I)
		deferred
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		deferred
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		deferred
		end

	fill_concave_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		deferred
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		deferred
		end

	fill_rectangle (x, y, a_width, a_height: DOUBLE)
		deferred
		end

feature -- Transform

	flip (a_width, a_height: INTEGER; mirror_state: NATURAL_8)
		deferred
		end

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		deferred
		end

	rotate_quarter (n: INTEGER)
		-- rotate `n * 90' degrees
		deferred
		end

	scale (x_factor, y_factor: DOUBLE)
		deferred
		end

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		deferred
		end

feature -- Status change

	remove_clip
		deferred
		end

	restore
			-- restore last drawing setting state from state stack
		deferred
		end

	save
			-- save current drawing setting state on to a stack
		deferred
		end

	set_antialias_best
		deferred
		end

feature {EV_ANY_I, EV_ANY_HANDLER} -- Implementation

	destroy
			-- Destroy `Current'.
		do
			set_is_destroyed (True)
		end

	surface: CAIRO_SURFACE_I
		deferred
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	interface: detachable CAIRO_DRAWING_AREA note option: stable attribute end;
		-- Interface object for `Current'.

end