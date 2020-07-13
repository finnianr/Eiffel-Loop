note
	description: "[
		Pixel buffer drawing using the [https://cairographics.org/ Cairo] and [http://www.pango.org/ Pangocairo]
		graphics libraries.
	]"
	instructions: "[
		When using 24 rgb format, make sure to lock pixmap before doing drawing operations
		and unlocking before calling to_pixmap.

		Note that for the Windows implementation you will need to distribute the Cairo, Pango and GTK DLLs with your application.
		It is recommended to use the Eiffel-Loop Scons build system for the initial application freeze as this will download the
		required DLL's and header files. See [https://github.com/finnianr/Eiffel-Loop/blob/master/Readme.md Readme.md]
			scons action=freeze project=<project-name>.ecf
		
		Doing a finalized build with scons will place the required DLLs under `package/<$ISE_PLATFORM>/bin'
			scons action=finalize project=<project-name>.ecf
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 17:27:35 GMT (Monday 13th July 2020)"
	revision: "21"

class
	EL_DRAWABLE_PIXEL_BUFFER

inherit
	EV_PIXEL_BUFFER
		rename
			draw_text as buffer_draw_text,
			draw_pixel_buffer as old_draw_pixel_buffer,
			make_with_size as make_rgb_24_with_size,
			make_with_pixmap as make_rgb_24_with_pixmap,
			set_with_named_path as set_rgb_24_with_path
		export
			{NONE} buffer_draw_text, draw_pixel_buffer_with_x_y, set_rgb_24_with_path
		undefine
			out
		redefine
			actual_implementation, create_implementation, implementation,
			to_pixmap, lock, unlock, height, width
		end

	EV_FONTABLE
		undefine
			out
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

	DEBUG_OUTPUT
		undefine
			default_create, copy
		redefine
			out
		end

	EL_IMAGE_DEBUG

create
	default_create,
	make_from_other,
	make_mirrored,
	make_scaled_to_height,
	make_scaled_to_width,
	make_with_path,
	make_with_rectangle,
	make_with_size,
	make_with_scaled_pixmap,
	make_with_pixmap,
	make_with_svg_image

feature {NONE} -- Initialization

	make_from_other (a_format: NATURAL_8; other: like Current)
		require
			valid_format: is_format_valid (a_format)
		do
			format := a_format; default_create
			implementation.make_from_other (other)
		end

	make_mirrored (other: like Current; axis: INTEGER)
		-- create copy mirrored in the y-axis
		require
			valid_axis: is_valid_axis (axis)
		do
			format := other.format; default_create
			implementation.make_mirrored (other, axis)
		end

	make_scaled (dimension: NATURAL_8; size: INTEGER; other: like Current)
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			rectangle: EL_RECTANGLE
		do
			create rectangle.make_scaled_for_pixels (other, dimension, size)
			make_with_size (32, rectangle.width, rectangle.height)
			draw_scaled_pixel_buffer (0, 0, size, dimension, other)
		end

	make_scaled_to_height (other: like Current; a_height: INTEGER)
		do
			make_scaled (By_height, a_height, other)
		end

	make_scaled_to_width (other: like Current; a_width: INTEGER)
		do
			make_scaled (By_width, a_width, other)
		end

	make_with_path (a_format: NATURAL_8; a_png_file_path: EL_FILE_PATH)
		-- make from a PNG file
		require
			valid_format: is_format_valid (a_format)
		do
			format := a_format; default_create
			implementation.set_with_path (a_png_file_path)
		end

	make_with_pixmap (a_format: NATURAL_8; a_pixmap: EV_PIXMAP)
			-- make alpha rgb 32 bit format
		require
			valid_format: is_format_valid (a_format)
		do
			format := a_format; default_create
			implementation.make_with_pixmap (a_pixmap)
		end

	make_with_rectangle (a_format: NATURAL_8; rectangle: EV_RECTANGLE)
		require
			valid_format: is_format_valid (a_format)
		do
			make_with_size (a_format, rectangle.width, rectangle.height)
		end

	make_with_scaled_pixmap (a_format, dimension: NATURAL_8; size: INTEGER; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
			valid_format: is_format_valid (a_format)
		do
			format := a_format; default_create
			implementation.make_with_scaled_pixmap (dimension, size, a_pixmap)
		end

	make_with_size (a_format: NATURAL_8; a_width, a_height: INTEGER)
		require
			valid_format: is_format_valid (a_format)
			a_width_valid: a_width > 0
			a_height_valid: a_height > 0
		do
			format := a_format
			default_create
			implementation.make_with_size (a_width, a_height)
		end

	make_with_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		do
			format := 32; default_create
			implementation.make_with_svg_image (svg_image, a_background_color)
		end

feature -- Measurement

	height: INTEGER
			-- Height of `Current' in pixels.
		do
			Result := actual_implementation.height
		end

	width: INTEGER
			-- Width of `Current' in pixels.
		do
			Result := actual_implementation.width
		end

feature -- Access

	debug_output, out: STRING
			-- Return readable string.
		do
			Result := Tag_template #$ [id, width, height]
		end

	format: NATURAL_8

	id: like internal_id
		do
			Result := internal_id
			if Result = Result.zero then
				Last_id.increment
				internal_id := Last_id.value
				Result := internal_id
			end
		end

feature -- Status query

	is_argb_32_format: BOOLEAN
		do
			Result := format = 32
		end

	is_rgb_24_format: BOOLEAN
		do
			Result := format = 24
		end

feature -- Drawing operations

	draw_line (x1, y1, x2, y2: INTEGER)
		do
			implementation.draw_line (x1, y1, x2, y2)
		end

	draw_pixel_buffer (x, y: INTEGER; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
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

	draw_rounded_pixel_buffer (x, y, radius, corners_bitmap: INTEGER; a_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.draw_rounded_pixel_buffer (x, y, radius, corners_bitmap, a_pixel_buffer)
		end

	draw_rounded_pixmap (x, y, radius, corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.draw_rounded_pixmap (x, y, radius, corners_bitmap, a_pixmap)
		end

	draw_scaled_pixel_buffer (x, y, a_size: INTEGER; dimension: NATURAL_8; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			implementation.draw_scaled_pixel_buffer (x, y, a_size, dimension, a_buffer)
		end

	draw_scaled_pixmap (x, y, a_size: INTEGER; dimension: NATURAL_8; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			implementation.draw_scaled_pixmap (x, y, a_size, dimension, a_pixmap)
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

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			implementation.save_as (file_path)
		end

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		do
			to_rgb_24_buffer.implementation.save_as_jpeg (file_path, quality)
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

	lock
		require else
			not_alpha_32_format: not is_argb_32_format
		do
			implementation.lock
		end

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

	unlock
		require else
			not_alpha_32_format: not is_argb_32_format
		do
			implementation.unlock
		end

feature -- Conversion

	quarter_rotated (n: INTEGER): like Current
		-- copy of buffer rotated `n * 90' degrees
		do
			if n.abs \\ 2 = 1 then
				create Result.make_with_size (32, height, width)
			else
				create Result.make_with_size (32, width, height)
			end
			Result.rotate_quarter (n)
			Result.draw_pixel_buffer (0, 0, Current)
		end

	to_pixmap: EL_PIXMAP
			-- Convert to EV_PIXMAP.
		do
			create Result.make_with_pixel_buffer (to_rgb_24_buffer)
		end

	to_rgb_24_buffer: EL_DRAWABLE_PIXEL_BUFFER
		require
			not_locked: not is_locked
		do
			if is_rgb_24_format then
				Result := Current
			else
				create Result.make_from_other (24, Current)
			end
		end

feature -- Contract Support

	is_format_valid (a_format: NATURAL_8): BOOLEAN
		do
			inspect a_format
				when 24, 32 then
					Result := True
			else
			end
		end

	locked_for_rgb_24_bit: BOOLEAN
		do
			Result := implementation.locked_for_rgb_24_bit
		end

feature {NONE} -- Implementation

	create_implementation
			-- Create implementation
		do
			create {EL_DRAWABLE_PIXEL_BUFFER_IMP} actual_implementation.make
			implementation := actual_implementation
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I, EL_DRAWABLE_CAIRO_CONTEXT, EL_DRAWABLE_PIXEL_BUFFER} -- Internal attributes

	actual_implementation: EL_DRAWABLE_PIXEL_BUFFER_IMP

	implementation: EL_DRAWABLE_PIXEL_BUFFER_I

	internal_id: NATURAL_16

feature {NONE} -- Constants

	Last_id: EL_MUTEX_NUMERIC [NATURAL_16]
		once
			create Result
		end

	Tag_template: ZSTRING
		once
			Result := "ID: %S Width: %S Height: %S"
		end

invariant
	valid_format: is_format_valid (format)
end
