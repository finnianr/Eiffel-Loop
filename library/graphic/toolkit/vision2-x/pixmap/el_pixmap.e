note
	description: "Pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 9:10:10 GMT (Sunday 2nd August 2020)"
	revision: "22"

class
	EL_PIXMAP

inherit
	EV_PIXMAP
		rename
			make_with_pixel_buffer as make_with_rgb_24
		undefine
			draw_text, draw_text_top_left, draw_ellipsed_text, draw_ellipsed_text_top_left, draw_sub_pixel_buffer
		redefine
			create_implementation, implementation, sub_pixmap, make_with_rgb_24
		end

	EL_DRAWABLE
		undefine
			copy, is_equal, is_in_default_state, sub_pixmap
		redefine
			implementation
		end

	EL_JPEG_CONVERTABLE
		rename
			to_pixel_surface as to_cairo_surface
		end

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		undefine
			is_equal, default_create, copy
		end

	EL_IMAGE_DEBUG

	EL_MODULE_SCREEN

create
	default_create,
	make_with_size, make_with_rectangle, make_scaled_to_width, make_scaled_to_height, make_scaled_to_size,
	make_with_pointer_style, make_with_rgb_24, make_with_argb_32,
	make_from_other, make_from_model

convert
	make_with_rectangle ({EV_RECTANGLE, EL_RECTANGLE}),
	dimensions: {EL_RECTANGLE}

feature {NONE} -- Initialization

	make_from_model (world: EV_MODEL_WORLD; area: detachable EV_RECTANGLE)
		local
			projector: EL_MODEL_PIXMAP_PROJECTOR
		do
			if attached area as rectangle then
				make_with_rectangle (rectangle)
			else
				make_with_rectangle (world.bounding_box)
			end
			create projector.make (world, Current)
			projector.full_project
		end

	make_from_other (other: EV_PIXMAP)
		do
			make_with_rgb_24 (create {EV_PIXEL_BUFFER}.make_with_pixmap (other))
		end

	make_scaled_to_height (other: EV_PIXMAP; a_height: INTEGER)
		do
			make_scaled_to_size (By_height, other, a_height)
		end

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		require
			valid_dimension: is_valid_dimension (dimension)
		do
			default_create
			implementation.make_scaled_to_size (dimension, other, size)
		end

	make_scaled_to_width (other: EV_PIXMAP; a_width: INTEGER)
		do
			make_scaled_to_size (By_width, other, a_width)
		end

	make_with_argb_32 (a_buffer: CAIRO_DRAWING_AREA)
		do
			default_create
			implementation.init_from_buffer (a_buffer)
		end

	make_with_rectangle (r: EV_RECTANGLE)
		do
			make_with_size (r.width, r.height)
		end

	make_with_rgb_24 (a_buffer: EV_PIXEL_BUFFER)
		do
			default_create
			implementation.init_from_pixel_buffer (a_buffer)
		end

feature -- Access

	dimensions: EL_RECTANGLE
		do
			create Result.make_size (width, height)
		end

	file_path: EL_FILE_PATH
		do
			Result := pixmap_path
		end

feature -- Scaling

	scale (a_factor: DOUBLE)
		local
			l_buffer: EV_PIXEL_BUFFER
		do
			create l_buffer.make_with_pixmap (Current)
			set_with_rgb_24_buffer (l_buffer.stretched ((width * a_factor).rounded, (height * a_factor).rounded))
		end

	scale_to_height (a_height: INTEGER)
		do
			scale (a_height / height)
		end

	scale_to_height_cms (a_height_cms: REAL)
		do
			scale (Screen.vertical_pixels (a_height_cms) / height)
		end

	scale_to_width (a_width: INTEGER)
		do
			scale (a_width / width)
		end

	scale_to_width_cms (a_width_cms: REAL)
		do
			scale (Screen.horizontal_pixels (a_width_cms) / width)
		end

feature -- Element change

	set_with_argb_32_buffer (a_buffer: CAIRO_DRAWING_AREA)
		do
			make_with_argb_32 (a_buffer)
		end

	set_with_rgb_24_buffer (a_buffer: EV_PIXEL_BUFFER)
		do
			make_with_rgb_24 (a_buffer)
		end

feature -- Duplication

	sub_pixmap (area: EV_RECTANGLE): EL_PIXMAP
		do
			create Result.make_with_size (area.width, area.height)
			Result.draw_sub_pixmap (0, 0, Current, area)
		end

feature -- Conversion

	to_drawing_area: CAIRO_DRAWING_AREA
		do
			create Result.make_with_pixmap (Current)
		end

	to_cairo_surface: CAIRO_PIXEL_SURFACE_I
		do
			create {CAIRO_PIXEL_SURFACE_IMP} Result.make_with_pixmap (Current)
		end

	to_buffer: EV_PIXEL_BUFFER
		do
			create Result.make_with_pixmap (Current)
		end

	to_scaled_buffer (dimension: NATURAL_8; size: INTEGER): EV_PIXEL_BUFFER
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			area: EL_RECTANGLE
		do
			area := dimensions
			area.scale_to_size (dimension, size)
			create Result.make_with_pixmap (Current)
			Result := Result.stretched (area.width, area.height)
		end

feature -- Basic operations

	save_as (a_file_path: EL_FILE_PATH)
		do
			save_to_named_file (create {EV_PNG_FORMAT}, a_file_path)
		end

feature {NONE} -- Implementation

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_PIXMAP_IMP} implementation.make
		end

	redraw
		do
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	implementation: EL_PIXMAP_I

end
