note
	description: "[
		Drawing area based on the [https://cairographics.org/ Cairo Graphics] 
		and [http://www.pango.org/ Pangocairo Graphics] libraries.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-13 11:47:41 GMT (Tuesday 13th February 2024)"
	revision: "15"

class
	CAIRO_DRAWING_AREA

inherit
	EV_FONTABLE
		redefine
			implementation, out
		end

	EL_JPEG_CONVERTABLE
		rename
			to_pixel_surface as to_surface
		end

	EL_RECTANGULAR

	EL_MODULE_ORIENTATION

	EL_IMAGE_DEBUG

create
	default_create, make_with_size, make_with_rectangle,
	make_with_path, make_with_png, make_with_pixmap, make_with_svg_image,
	make_with_scaled_pixmap, make_scaled_to_width, make_scaled_to_height, make_scaled_to_size

convert
	make_with_path ({FILE_PATH}), make_with_pixmap ({EV_PIXMAP, EL_PIXMAP}),
	dimensions: {EL_RECTANGLE}, to_buffer: {EV_PIXEL_BUFFER}

feature {NONE} -- Initialization

	make_filled_scaled_to_width (other: CAIRO_DRAWING_AREA; background: EV_COLOR; a_width: INTEGER)
		-- draw `other' scaled to `a_width' with transparent areas filled by `background' color
		do
			make_scaled (Orientation.By_width, a_width, other, background)
		end

	make_scaled (dimension: NATURAL_8; size: INTEGER; other: CAIRO_DRAWING_AREA; fill_color: detachable EV_COLOR)
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			make_with_rectangle (other.scaled_dimensions (dimension, size))
			if attached fill_color as background then
				set_color (background); fill
			end
			draw_scaled_area (dimension, 0, 0, size, other)
		end

	make_scaled_to_height (other: CAIRO_DRAWING_AREA; a_height: INTEGER; fill_color: detachable EV_COLOR)
		-- draw `other' scaled to `a_height' with transparent areas filled by optional `background' color
		do
			make_scaled (Orientation.By_height, a_height, other, fill_color)
		end

	make_scaled_to_width (other: CAIRO_DRAWING_AREA; a_width: INTEGER; fill_color: detachable EV_COLOR)
		do
			make_scaled (Orientation.By_width, a_width, other, fill_color)
		end

	make_scaled_to_size (other: CAIRO_DRAWING_AREA; a_width, a_height: INTEGER; fill_color: detachable EV_COLOR)
		-- make area scaled to greater of dimension: `a_width' or `a_height'
		local
			l_width, l_height: INTEGER
		do
			l_width := a_width.max (1); l_height := a_height.max (1);
			if l_width >= l_height then
				make_scaled_to_width (other, l_width, fill_color)
			else
				make_scaled_to_height (other, l_height, fill_color)
			end
		end

	make_with_path (image_path: FILE_PATH)
		-- make from an image file
		require
			path_exists: image_path.exists
		do
			default_create
			implementation.make_with_path (image_path)
		end

	make_with_png (png_path: FILE_PATH)
		-- make from an image file
		require
			path_exists: png_path.exists
		do
			default_create
			implementation.set_with_png (png_path)
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		do
			default_create
			implementation.make_with_pixmap (a_pixmap)
		end

	make_with_rectangle (rectangle: EV_RECTANGLE)
		do
			make_with_size (rectangle.width, rectangle.height)
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; size: INTEGER; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			default_create
			implementation.make_with_scaled_pixmap (dimension, size, a_pixmap)
		end

	make_with_size (a_width, a_height: INTEGER)
		require
			width_valid: a_width > 0
			height_valid: a_height > 0
		do
			default_create
			implementation.make_with_size (a_width, a_height)
		end

	make_with_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		do
			default_create
			implementation.make_with_svg_image (svg_image, a_background_color)
		end

feature -- Access

	debug_output, out: STRING
			-- Return readable string.
		do
			Result := Tag_template #$ [id, width, height]
		end

	id: like internal_id
		do
			Result := internal_id
			if Result = Result.zero then
				Last_id.increment
				internal_id := Last_id.item
				Result := internal_id
			end
		end

feature -- Measurement

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

feature -- Conversion

	scaled_to_height (a_height: INTEGER; fill_color: detachable EV_COLOR): CAIRO_DRAWING_AREA
		do
			create Result.make_scaled_to_height (Current, a_height, fill_color)
		end

	scaled_to_size (a_width, a_height: INTEGER; fill_color: detachable EV_COLOR): CAIRO_DRAWING_AREA
		-- scaled to greater of `a_width' and `a_height'
		do
			create Result.make_scaled_to_size (Current, a_width, a_height, fill_color)
		end

	scaled_to_width (a_width: INTEGER; fill_color: detachable EV_COLOR): CAIRO_DRAWING_AREA
		do
			create Result.make_scaled_to_width (Current, a_width, fill_color)
		end

	to_buffer: EV_PIXEL_BUFFER
		-- Vision-2 pixel buffer
		do
			Result := implementation.to_buffer
		end

	to_pixmap: EL_PIXMAP
		-- Convert to EV_PIXMAP.
		do
			create Result.make_with_argb_32 (Current)
		end

	to_surface: CAIRO_PIXEL_SURFACE_I
		-- Cairo pixmap surface
		-- don't forget to call destroy on result for Windows
		do
			Result := implementation.to_surface
		end

feature -- Basic operations

	save_as (file_path: FILE_PATH)
			-- Save as png file
		do
			implementation.save_as (file_path)
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

	set_with_path (file_path: FILE_PATH)
		do
			implementation.set_with_png (file_path)
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

feature -- Draw text

	draw_centered_text (a_text: READABLE_STRING_GENERAL; rectangle: EL_RECTANGLE)
		-- draw `a_text' centered in `rectangle'
		do
			if attached rectangle.centered_text (rectangle, a_text, font) as rect then
				draw_text_top_left (rect.x, rect.y, a_text)
			end
		end

	draw_rotated_text (rectangle: EL_TEXT_RECTANGLE; a_angle: DOUBLE)
		do
			implementation.draw_rotated_text (rectangle, a_angle)
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_rotated_text_top_left (x, y, angle, a_text)
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_text (x, y, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			implementation.draw_text_top_left (x, y, a_text)
		end

feature -- Draw pixmaps

	draw_fitted_pixmap (pixmap: EL_PIXMAP)
		-- draw `pixmap' scaled and centered to fit in current area
		do
			if attached pixmap.fit_adjustment (dimensions) as fit then
				if fit.dimension.to_boolean then
					draw_scaled_pixmap (fit.dimension, fit.x, fit.y, fit.size, pixmap)
				else
					draw_pixmap (0, 0, pixmap)
				end
			end
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		do
			implementation.draw_pixmap (x, y, a_pixmap)
		end

	draw_rounded_pixmap (x, y, radius, corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. `Top_left | Top_right'
		do
			implementation.draw_rounded_pixmap (x, y, radius, corners_bitmap, a_pixmap)
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: INTEGER; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			implementation.draw_scaled_pixmap (dimension, x, y, a_size, a_pixmap)
		end

feature -- Draw drawing area

	draw_area (x, y: INTEGER; drawing: CAIRO_DRAWING_AREA)
		do
			implementation.draw_area (x, y, drawing)
		end

	draw_fitted_area (drawing: CAIRO_DRAWING_AREA)
		-- draw `drawing' scaled and centered to fit in current area
		do
			if attached drawing.fit_adjustment (dimensions) as fit then
				if fit.dimension.to_boolean then
					draw_scaled_area (fit.dimension, fit.x, fit.y, fit.size, drawing)
				else
					draw_area (0, 0, drawing)
				end
			end
		end

	draw_rounded_area (x, y, radius, corners_bitmap: INTEGER; drawing: CAIRO_DRAWING_AREA)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. `Top_left | Top_right'
		do
			implementation.draw_rounded_area (x, y, radius, corners_bitmap, drawing)
		end

	draw_scaled_area (dimension: NATURAL_8; x, y, a_size: INTEGER; drawing: CAIRO_DRAWING_AREA)
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			implementation.draw_scaled_area (dimension, x, y, a_size, drawing)
		end

feature -- Draw a surface

	draw_fitted_surface (a_surface: CAIRO_SURFACE_I)
		-- draw `a_surface' scaled and centered to fit in current area
		do
			if attached a_surface.fit_adjustment (dimensions) as fit then
				if fit.dimension.to_boolean then
					draw_scaled_surface (fit.dimension, fit.x, fit.y, fit.size, a_surface)
				else
					draw_surface (0, 0, a_surface)
				end
			end
		end

	draw_scaled_surface (dimension: NATURAL_8; x, y, size: DOUBLE; a_surface: CAIRO_SURFACE_I)
		do
			implementation.draw_scaled_surface (dimension, x, y, size, a_surface)
		end

	draw_surface (x, y: DOUBLE; source: CAIRO_SURFACE_I)
		do
			implementation.draw_surface (x, y, source)
		end

feature -- Drawing operations

	draw_line (x1, y1, x2, y2: INTEGER)
		do
			implementation.draw_line (x1, y1, x2, y2)
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		do
			implementation.draw_rectangle (x, y, a_width, a_height)
		end

	draw_rotated_rectangle (rectangle: EV_RECTANGLE; a_angle: DOUBLE)
		do
			implementation.draw_rotated_rectangle (rectangle, a_angle)
		end

feature -- Filling operations

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

feature {NONE} -- Implementation

	create_implementation
			-- Create implementation
		do
			create {CAIRO_DRAWING_AREA_IMP} implementation.make
		end

	create_interface_objects
		do
		end

feature {EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	implementation: CAIRO_DRAWING_AREA_I
		-- Implementation interface

	internal_id: NATURAL_16

feature {NONE} -- Constants

	Last_id: EL_MUTEX_NUMERIC [NATURAL_16]
		once
			create Result.make
		end

	Tag_template: ZSTRING
		once
			Result := "ID: %S Width: %S Height: %S"
		end

end