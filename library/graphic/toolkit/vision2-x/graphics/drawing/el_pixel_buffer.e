note
	description: "[
		Pixel buffer drawing providing access to the [https://cairographics.org/ Cairo] 
		and [http://www.pango.org/ Pangocairo] graphics libraries.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 16:03:24 GMT (Friday 31st July 2020)"
	revision: "2"

class
	EL_PIXEL_BUFFER

inherit
	EV_FONTABLE
		redefine
			implementation
		end

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		undefine
			default_create, copy, out
		end

	EL_IMAGE_DEBUG

create
	make_with_scaled_pixmap, make_with_path

convert
	dimensions: {EL_RECTANGLE}

feature {NONE} -- Initialization

	make_with_path (file_path: EL_FILE_PATH)
		-- make from an image file
		require
			path_exists: file_path.exists
		do
			default_create
			implementation.set_with_path (file_path)
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; size: INTEGER; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			default_create
			implementation.make_with_scaled_pixmap (dimension, size, a_pixmap)
		end

feature -- Measurement

	dimensions: EL_RECTANGLE
		do
			create Result.make_size (width, height)
		end

	height: INTEGER
			-- Height
		do
			Result := implementation.height
		end

	width: INTEGER
			-- Width
		do
			Result := implementation.width
		end

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			implementation.save_as (file_path)
		end

feature -- Drawing operations

	draw_line (x1, y1, x2, y2: INTEGER)
		do
			implementation.draw_line (x1, y1, x2, y2)
		end

	draw_pixel_buffer (x, y: INTEGER; a_buffer: EL_PIXEL_BUFFER)
		do
			implementation.draw_pixel_buffer (x, y, a_buffer)
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		do
			implementation.draw_rectangle (x, y, a_width, a_height)
		end

	draw_rotated_rectangle (rectangle: EV_RECTANGLE; a_angle: DOUBLE)
		do
			implementation.draw_rotated_rectangle (rectangle, a_angle)
		end

	draw_rotated_text (rectangle: EL_TEXT_RECTANGLE; a_angle: DOUBLE)
		do
			implementation.draw_rotated_text (rectangle, a_angle)
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_rotated_text_top_left (x, y, angle, a_text)
		end

	draw_rounded_pixel_buffer (x, y, radius, corners_bitmap: INTEGER; a_pixel_buffer: EL_PIXEL_BUFFER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. `Top_left | Top_right'
		do
			implementation.draw_rounded_pixel_buffer (x, y, radius, corners_bitmap, a_pixel_buffer)
		end

	draw_rounded_pixmap (x, y, radius, corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. `Top_left | Top_right'
		do
			implementation.draw_rounded_pixmap (x, y, radius, corners_bitmap, a_pixmap)
		end

	draw_scaled_pixel_buffer (dimension: NATURAL_8; x, y, a_size: INTEGER; a_buffer: EL_PIXEL_BUFFER)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			implementation.draw_scaled_pixel_buffer (dimension, x, y, a_size, a_buffer)
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: INTEGER; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			implementation.draw_scaled_pixmap (dimension, x, y, a_size, a_pixmap)
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_text (x, y, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_text_top_left (x, y, a_text)
		end

	fill
		do
			implementation.fill_rectangle (0, 0, width, height)
		end

	fill_concave_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. `Top_left | Top_right'
		do
			implementation.fill_concave_corners (radius, corners_bitmap)
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. `Top_left | Top_right'
		do
			implementation.fill_convex_corners (radius, corners_bitmap)
		end

	fill_rectangle (x, y, a_width, a_height: INTEGER)
		do
			implementation.fill_rectangle (x, y, a_width, a_height)
		end

feature -- Conversion

	to_pixmap: EL_PIXMAP
		-- Convert to EV_PIXMAP.
		do
			create Result.make_with_buffer (Current)
		end

feature -- Element change

	set_color (a_color: EV_COLOR)
		do
			implementation.set_color (a_color)
		end

	set_line_width (size: INTEGER)
		do
			implementation.set_line_width (size)
		end

	set_opacity (percentage: INTEGER)
		require
			is_percentage: 0 <= percentage and percentage <= 100
		do
			implementation.set_opacity (percentage)
		end

	set_opaque
		do
			implementation.set_opaque
		end

	set_with_path (file_path: EL_FILE_PATH)
		do
			implementation.set_with_path (file_path)
		end

feature -- Transform

	flip (a_width, a_height: INTEGER; mirror_state: NATURAL_8)
		-- mirror_state is bit OR'd combination of `X_axis' and `Y_axis'
		do
			implementation.flip (a_width, a_height, mirror_state)
		end

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		do
			implementation.rotate (angle)
		end

	rotate_quarter (n: INTEGER)
		-- rotate `n * 90' degrees
		do
			implementation.rotate_quarter (n)
		end

	scale (x_factor, y_factor: DOUBLE)
		do
			implementation.scale (x_factor, y_factor)
		end

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		do
			implementation.translate (x, y)
		end

feature -- Status change

	restore
			-- restore last drawing setting state from state stack
		do
			implementation.restore
		end

	save
			-- save current drawing setting state on to a stack
		do
			implementation.save
		end

	set_antialias_best
		do
			implementation.set_antialias_best
		end

feature {NONE} -- Implementation

	create_implementation
			-- Create implementation
		do
			create {EL_PIXEL_BUFFER_IMP} implementation.make
		end

	create_interface_objects
		do
		end

feature {EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	implementation: EL_PIXEL_BUFFER_I
		-- Implementation interface

end
