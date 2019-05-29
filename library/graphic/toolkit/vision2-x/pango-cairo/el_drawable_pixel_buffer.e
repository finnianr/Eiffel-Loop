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
	date: "2019-05-28 17:30:14 GMT (Tuesday 28th May 2019)"
	revision: "7"

class
	EL_DRAWABLE_PIXEL_BUFFER

inherit
	EV_PIXEL_BUFFER
		rename
			draw_text as buffer_draw_text,
			draw_pixel_buffer as old_draw_pixel_buffer,
			make_with_size as make_rgb_24_with_size,
			set_with_named_path as set_with_path_as_rgb_24
		export
			{NONE} buffer_draw_text, draw_pixel_buffer_with_x_y
		redefine
			make_with_pixmap, make_rgb_24_with_size, actual_implementation, create_implementation, implementation,
			to_pixmap, lock, unlock, set_with_path_as_rgb_24
		end

	EV_FONTABLE
		redefine
			implementation
		end

	EL_ORIENTATION_CONSTANTS
		undefine
			default_create, copy
		end

create
	default_create, make_with_pixmap, make_with_size, make_rgb_24_with_pixmap, make_rgb_24_with_size, make_with_path,
	make_from_svg_image, make_rgb_24_with_sized_pixmap

convert
	make_with_pixmap ({EL_PIXMAP})

feature {NONE} -- Initialization

	make_from_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		do
			default_create
			implementation.make_from_svg_image (svg_image, a_background_color)
		end

	make_rgb_24_with_pixmap (a_pixmap: EV_PIXMAP)
			-- make rgb 24 bit format
		do
			default_create
			implementation.make_rgb_24_with_pixmap (a_pixmap)
		end

	make_rgb_24_with_size (a_width, a_height: INTEGER)
			-- make rgb 24 bit format
		do
			default_create
			implementation.make_rgb_24_with_size (a_width, a_height)
		end

	make_rgb_24_with_sized_pixmap (a_size, dimension: INTEGER; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			if dimension = By_width then
				make_rgb_24_with_size (a_size, (a_pixmap.height * a_size / a_pixmap.width).floor)
			else
				make_rgb_24_with_size ((a_pixmap.width * a_size / a_pixmap.height).floor, a_size)
			end
			draw_scaled_pixmap (0, 0, a_size, dimension, a_pixmap)
		end

	make_with_path (a_png_file_path: EL_FILE_PATH)
		-- make from a PNG file
		do
			default_create
			implementation.set_with_path (a_png_file_path)
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
			-- make alpha rgb 32 bit format
		do
			default_create
			implementation.make_with_pixmap (a_pixmap)
		end

	make_with_size (a_width, a_height: INTEGER)
			--- make alpha rgb 32 bit format
		require
			a_width_valid: a_width > 0
			a_height_valid: a_height > 0
		do
			default_create
			implementation.make_with_size (a_width, a_height)
		end

feature -- Status query

	is_alpha_rgb_32_bit: BOOLEAN
		do
			Result := implementation.is_alpha_rgb_32_bit
		end

	is_rgb_24_bit: BOOLEAN
		do
			Result := implementation.is_rgb_24_bit
		end

feature -- Basic operations

	draw_line (x1, y1, x2, y2: INTEGER)
		do
			implementation.draw_line (x1, y1, x2, y2)
		end

	draw_pixel_buffer (x, y: INTEGER; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			implementation.draw_pixel_buffer (x, y, a_buffer.implementation)
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		do
			implementation.draw_rectangle (x, y, a_width, a_height)
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_rotated_text_top_left (x, y, angle, a_text)
		end

	draw_rounded_pixel_buffer (x, y, radius, corners_bitmap: INTEGER; a_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.set_clip_rounded_rectangle (
				x, y, a_pixel_buffer.width, a_pixel_buffer.height, radius, corners_bitmap
			)
			implementation.draw_pixel_buffer (x, y, a_pixel_buffer.implementation)
		end

	draw_rounded_pixmap (x, y, radius, corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.set_clip_rounded_rectangle (x, y, a_pixmap.width, a_pixmap.height, radius, corners_bitmap)
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_scaled_pixel_buffer (x, y, a_size, dimension: INTEGER; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			implementation.draw_scaled_pixel_buffer (x, y, a_size, dimension, a_buffer)
		end

	draw_scaled_pixmap (x, y, a_size, dimension: INTEGER; a_pixmap: EV_PIXMAP)
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
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.fill_concave_corners (radius, corners_bitmap)
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.fill_convex_corners (radius, corners_bitmap)
		end

	fill_rectangle (x, y, a_width, a_height: INTEGER)
		do
			implementation.fill_rectangle (x, y, a_width, a_height)
		end

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			implementation.save_as (file_path)
		end

feature -- Element change

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			implementation.set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap)
		end

	set_color (a_color: EL_COLOR)
		do
			implementation.set_color (a_color)
		end

	set_line_width (size: INTEGER)
		do
			implementation.set_line_width (size)
		end

	set_with_path (file_path: EL_FILE_PATH)
		do
			implementation.set_with_path (file_path)
		end

	set_with_path_as_rgb_24 (a_file_name: PATH)
		do
			implementation.set_with_named_path_as_rgb_24 (a_file_name)
		end

feature -- Transform

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		do
			implementation.rotate (angle)
		end

	scale (x_factor, y_factor: REAL_64)
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
			not_alpha_32_format: not is_alpha_rgb_32_bit
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
			not_alpha_32_format: not is_alpha_rgb_32_bit
		do
			implementation.unlock
		end

feature -- Conversion

	to_pixmap: EL_PIXMAP
			-- Convert to EV_PIXMAP.
		do
			create Result.make_with_pixel_buffer (to_rgb_24_buffer)
		end

	to_rgb_24_buffer: EL_DRAWABLE_PIXEL_BUFFER
		require
			not_locked: not is_locked
		do
			Result := implementation.to_rgb_24_buffer
		end

feature {NONE} -- Implementation

	create_implementation
			-- Create implementation
		do
			create {EL_DRAWABLE_PIXEL_BUFFER_IMP} actual_implementation.make
			implementation := actual_implementation
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I, EL_DRAWABLE_PIXEL_BUFFER} -- Implementation

	actual_implementation: EL_DRAWABLE_PIXEL_BUFFER_IMP

	implementation: EL_DRAWABLE_PIXEL_BUFFER_I

end
