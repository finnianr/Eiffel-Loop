note
	description: "[
		Pixel drawing using cairo and pangocairo libraries.
		When using 24 rgb format, make sure to lock pixmap before doing drawing operations
		and unlocking before calling to_pixmap.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-06 12:17:32 GMT (Monday 6th July 2015)"
	revision: "3"

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
			{NONE} buffer_draw_text
		redefine
			make_with_pixmap, make_rgb_24_with_size, actual_implementation, create_implementation, implementation,
			to_pixmap, lock, unlock, set_with_path_as_rgb_24, width, height
		end

	EV_FONTABLE
		redefine
			implementation
		end

create
	default_create, make_with_pixmap, make_with_size, make_rgb_24_with_pixmap, make_rgb_24_with_size, make_with_path,
	make_from_svg_image

convert
	make_with_pixmap ({EL_PIXMAP})

feature {NONE} -- Initialization

	make_with_size (a_width, a_height: INTEGER)
			--- make alpha rgb 32 bit format
		require
			a_width_valid: a_width > 0
			a_height_valid: a_height > 0
		do
			default_create
			implementation.make_with_size (a_width, a_height)
		end

	make_rgb_24_with_size (a_width, a_height: INTEGER)
			-- make rgb 24 bit format
		do
			default_create
			implementation.make_rgb_24_with_size (a_width, a_height)
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
			-- make alpha rgb 32 bit format
		do
			default_create
			implementation.make_with_pixmap (a_pixmap)
		end

	make_rgb_24_with_pixmap (a_pixmap: EV_PIXMAP)
			-- make rgb 24 bit format
		do
			default_create
			implementation.make_rgb_24_with_pixmap (a_pixmap)
		end

	make_with_path (a_png_file_path: EL_FILE_PATH)
		do
			default_create
			implementation.set_with_path (a_png_file_path)
		end

	make_from_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		do
			default_create
			implementation.make_from_svg_image (svg_image, a_background_color)
		end

feature -- Measurement

	width: INTEGER
		do
			Result := implementation.width
		end

	height: INTEGER
		do
			Result := implementation.height
		end

feature -- Status query

	is_rgb_24_bit: BOOLEAN
		do
			Result := implementation.is_rgb_24_bit
		end

	is_is_alpha_rgb_32_bit: BOOLEAN
		do
			Result := implementation.is_alpha_rgb_32_bit
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

	draw_scaled_pixel_buffer (x, y, size: INTEGER; size_is_width: BOOLEAN; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			implementation.draw_scaled_pixel_buffer (x, y, size,size_is_width, a_buffer)
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_rounded_pixmap (x, y, radius: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.set_clip_rounded_rectangle (x, y, a_pixmap.width, a_pixmap.height, radius)
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_rounded_pixel_buffer (x, y, radius: INTEGER; a_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			implementation.set_clip_rounded_rectangle (x, y, a_pixel_buffer.width, a_pixel_buffer.height, radius)
			implementation.draw_pixel_buffer (x, y, a_pixel_buffer.implementation)
		end

	draw_top_rounded_pixmap (x, y, radius: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.set_clip_top_rounded_rectangle (x, y, a_pixmap.width, a_pixmap.height, radius)
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_top_rounded_pixel_buffer (x, y, radius: INTEGER; a_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			implementation.set_clip_top_rounded_rectangle (x, y, a_pixel_buffer.width, a_pixel_buffer.height, radius)
			implementation.draw_pixel_buffer (x, y, a_pixel_buffer.implementation)
		end

	draw_bottom_rounded_pixmap (x, y, radius: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.set_clip_bottom_rounded_rectangle (x, y, a_pixmap.width, a_pixmap.height, radius)
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_bottom_rounded_pixel_buffer (x, y, radius: INTEGER; a_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			implementation.set_clip_bottom_rounded_rectangle (x, y, a_pixel_buffer.width, a_pixel_buffer.height, radius)
			implementation.draw_pixel_buffer (x, y, a_pixel_buffer.implementation)
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		do
			implementation.draw_rectangle (x, y, a_width, a_height)
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_text (x, y, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_text_top_left (x, y, a_text)
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_rotated_text_top_left (x, y, angle, a_text)
		end

	fill_concave_corner_bottom_left (x, y, radius: INTEGER)
		do
			implementation.fill_concave_corner_bottom_left (x, y, radius)
		end

	fill_concave_corner_bottom_right (x, y, radius: INTEGER)
		do
			implementation.fill_concave_corner_bottom_right (x, y, radius)
		end

	fill_concave_corner_top_left (x, y, radius: INTEGER)
		do
			implementation.fill_concave_corner_top_left (x, y, radius)
		end

	fill_concave_corner_top_right (x, y, radius: INTEGER)
		do
			implementation.fill_concave_corner_top_right (x, y, radius)
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

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius: INTEGER)
		do
			implementation.set_clip_rounded_rectangle (x, y, a_width, a_height, radius)
		end

	set_clip_top_rounded_rectangle (x, y, a_width, a_height, radius: INTEGER)
		do
			implementation.set_clip_top_rounded_rectangle (x, y, a_width, a_height, radius)
		end

	set_clip_bottom_rounded_rectangle (x, y, a_width, a_height, radius: INTEGER)
		do
			implementation.set_clip_bottom_rounded_rectangle (x, y, a_width, a_height, radius)
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

feature -- Status change

	set_antialias_best
		do
			implementation.set_antialias_best
		end

	translate (x, y: INTEGER)
			-- translate coordinate origin to point x, y
		do
			implementation.translate (x, y)
		end

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		do
			implementation.rotate (angle)
		end

	scale (x_factor, y_factor: REAL_64)
		do
			implementation.scale (x_factor, y_factor)
		end

	save
			-- save current drawing setting state on to a stack
		do
			implementation.save
		end

	restore
			-- restore last drawing setting state from state stack
		do
			implementation.restore
		end

	lock
		require else
			not_alpha_32_format: not is_is_alpha_rgb_32_bit
		do
			implementation.lock
		end

	unlock
		require else
			not_alpha_32_format: not is_is_alpha_rgb_32_bit
		do
			implementation.unlock
		end

feature -- Conversion

	to_pixmap: EL_PIXMAP
			-- Convert to EV_PIXMAP.
		require else
			not_locked: not is_locked
		do
			Result := implementation.to_pixmap
		end

feature {NONE} -- Implementation

	create_implementation
			-- Create implementation
		do
			create {EL_DRAWABLE_PIXEL_BUFFER_IMP} actual_implementation.make
			implementation := actual_implementation
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I, EL_DRAWABLE_PIXEL_BUFFER} -- Implementation

	implementation: EL_DRAWABLE_PIXEL_BUFFER_I

	actual_implementation: EL_DRAWABLE_PIXEL_BUFFER_IMP

end
