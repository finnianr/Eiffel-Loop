note
	description: "Drawable Cairo context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 15:50:45 GMT (Friday 31st July 2020)"
	revision: "7"

deferred class
	CAIRO_DRAWABLE_CONTEXT_I

inherit
	EL_OWNED_C_OBJECT
		rename
			self_ptr as context
		export
			{EL_DRAWABLE_PIXEL_BUFFER_I, EL_SVG_IMAGE, CAIRO_DRAWABLE_CONTEXT_I} context
		end

	CAIRO_COMMAND_CONTEXT

	EV_ANY_HANDLER

	EL_GEOMETRY_MATH
		export
			{NONE} all
			{ANY} is_valid_corner, is_valid_dimension
		end

feature {NONE} -- Initialization

	make (a_surface: CAIRO_SURFACE_I)
		do
			create color
			set_opaque
			surface := a_surface
			if a_surface.is_initialized then
				make_from_pointer (a_surface.new_context)
			end
		end

feature -- Access

	color: EV_COLOR

feature -- Measurement

	height: INTEGER
		do
			Result := surface.height
		end

	opacity: INTEGER
		-- percentage opacity. 100 is totally opaque

	rotation_angle: DOUBLE

	width: INTEGER
		do
			Result := surface.width
		end

feature -- Element change

	set_color (a_color: like color)
		do
			color := a_color
			set_source_color
		end

	set_opacity (percentage: INTEGER)
		do
			opacity := percentage
		end

	set_opaque
		do
			opacity := 100
		end

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		do
			surface.save_as (file_path)
		end

feature -- Transformations

	flip (a_width, a_height: INTEGER; mirror_state: NATURAL_8)
		-- mirror_state is bit OR'd combination of `X_axis' and `Y_axis'
		local
			x_factor, y_factor, l_width, l_height: DOUBLE
		do
			if mirror_state.to_boolean then
				x_factor := x_factor.one; y_factor := y_factor.one
				if (mirror_state & X_axis).to_boolean then
					l_height := a_height; y_factor := y_factor.opposite
				end
				if (mirror_state & Y_axis).to_boolean then
					l_width := a_width; x_factor := x_factor.opposite
				end
				translate (l_width, l_height)
				scale (x_factor, y_factor)
			end
		end

	rotate (angle: DOUBLE)
		do
			Cairo.rotate (context, angle)
			rotation_angle := angle
		end

	rotate_quarter (n: INTEGER)
		-- rotate `n * 90' degrees
		local
			half_width, half_height: DOUBLE
		do
			if n /= 0 then
				half_width := (width / 2).rounded; half_height := (height / 2).rounded
				translate (half_width, half_height)
				rotate (n * {MATH_CONST}.Pi_2)
				if n.abs \\ 2 = 1 then
					translate (half_height.opposite, half_width.opposite)
				else
					translate (half_width.opposite, half_height.opposite)
				end
			end
		end

	scale (x_factor, y_factor: DOUBLE)
		do
			Cairo.scale (context, x_factor, y_factor)
		end

	scale_by (factor: DOUBLE)
		do
			scale (factor, factor)
		end

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		do
			Cairo.translate (context, x, y)
		end

feature -- Status change

	set_antialias_best
		do
			Cairo.set_antialias (context, Cairo.Antialias_best)
		end

	set_clip_concave_corner (x, y, radius, corner: INTEGER)
		require
			valid_corner: is_valid_corner (corner)
		do
			define_sub_path
			inspect corner
				when Top_left then
					move_to (x, y)
					arc (x + radius, y + radius, radius, radians (180), radians (270))
				when Top_right then
					move_to (x + radius, y)
					arc (x, y + radius, radius, radians (90).opposite, 0.0)
				when Bottom_right then
					move_to (x + radius, y + radius)
					arc (x, y, radius, 0.0, radians (90))
				when Bottom_left then
					move_to (x, y + radius)
					arc (x + radius, y, radius, radians (90), radians (180))
			else end
			close_sub_path
			clip
		end

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius: DOUBLE; corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		do
			define_sub_path
			if (Top_right & corners_bitmap).to_boolean then
				arc (x + a_width - radius, y + radius, radius, radians (90).opposite, 0.0);
			else
				line_to (x + a_width, y)
			end
			if (Top_left & corners_bitmap).to_boolean then
				arc (x + radius, y + radius, radius, radians (180), radians (270));
			else
				line_to (x, y)
			end
			if (Bottom_right & corners_bitmap).to_boolean then
				arc (x + a_width - radius, y + a_height - radius, radius, 0.0, radians (90));
			else
				line_to (x + a_width, y + a_height)
			end
			if (Bottom_left & corners_bitmap).to_boolean then
				arc (x + radius, y + a_height - radius, radius, radians (90), radians (180));
			else
				line_to (x, y + a_height)
			end
			close_sub_path
			clip
		end

	set_line_width (size: INTEGER)
		do
			Cairo.set_line_width (context, size)
		end

	set_source_pattern (pattern: CAIRO_PATTERN)
		do
			Cairo.set_source (context, pattern.self_ptr)
		end

	set_source_surface (a_surface: CAIRO_SURFACE_I; x, y: DOUBLE)
		do
			Cairo.set_source_surface (context, a_surface.self_ptr, x, y)
		end

	set_surface_color_order
		-- set color channel order (needed for Unix)
		do
			surface.set_surface_color_order
		end

feature -- Drawing operations

	draw_line (x1, y1, x2, y2: INTEGER)
		local
			l_antialias: INTEGER
		do
			move_to (x1, y1)
			if rotation_angle = rotation_angle.zero then
				l_antialias := Cairo.antialias (context)
				Cairo.set_antialias (context, Cairo.Antialias_none)
			end
			line_to (x2, y2)
			stroke
			if rotation_angle = rotation_angle.zero then
				Cairo.set_antialias (context, l_antialias)
			end
		end

	draw_pixel_buf (x, y: DOUBLE; buffer: EL_PIXEL_BUFFER)
		do
			if attached buffer.implementation as l_buffer then
				draw_surface (x, y, l_buffer.cairo.surface)
			end
		end

	draw_pixel_buffer (x, y: DOUBLE; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			if attached buffer.implementation as l_buffer then
				draw_surface (x, y, l_buffer.cairo_context.surface)
			end
		end

	draw_pixmap (x, y: DOUBLE; pixmap: EV_PIXMAP)
		local
			l_surface: CAIRO_PIXEL_SURFACE_I
		do
			create {CAIRO_PIXEL_SURFACE_IMP} l_surface.make_with_pixmap (pixmap)
			draw_surface (x, y, l_surface)
			l_surface.destroy
		end

	draw_rectangle (x, y, a_width, a_height: DOUBLE)
		local
			l_antialias: INTEGER
		do
			Cairo.rectangle (context, x + 1, y + 1, a_width, a_height)
			if rotation_angle = rotation_angle.zero then
				l_antialias := Cairo.antialias (context)
				Cairo.set_antialias (context, Cairo.Antialias_none)
			end
			stroke
			if rotation_angle = rotation_angle.zero then
				Cairo.set_antialias (context, l_antialias)
			end
		end

	draw_rotated_rectangle (rectangle: EV_RECTANGLE; a_angle: DOUBLE)
		do
			save
			translate (rectangle.x, rectangle.y)
			rotate (a_angle)
			draw_rectangle (0, 0, rectangle.width, rectangle.height)
			restore
		end

	draw_rounded_pixel_buf (x, y, radius: DOUBLE; corners_bitmap: INTEGER; buffer: EL_PIXEL_BUFFER)
		do
			set_clip_rounded_rectangle (x, y, buffer.width, buffer.height, radius, corners_bitmap)
			draw_pixel_buf (x, y, buffer)
			reset_clip
		end

	draw_rounded_pixel_buffer (x, y, radius: DOUBLE; corners_bitmap: INTEGER; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			set_clip_rounded_rectangle (x, y, buffer.width, buffer.height, radius, corners_bitmap)
			draw_pixel_buffer (x, y, buffer)
			reset_clip
		end

	draw_rounded_pixmap (x, y, radius: DOUBLE; corners_bitmap: INTEGER; a_pixmap: EV_PIXMAP)
		do
			set_clip_rounded_rectangle (x, y, a_pixmap.width, a_pixmap.height, radius, corners_bitmap)
			draw_pixmap (x, y, a_pixmap)
			reset_clip
		end

	draw_scaled_pixel_buf (dimension: NATURAL_8; x, y, size: DOUBLE; buffer: EL_PIXEL_BUFFER)
		do
			draw_scaled_surface (dimension, x, y, size, buffer.implementation.cairo.surface)
		end

	draw_scaled_pixel_buffer (dimension: NATURAL_8; x, y, size: DOUBLE; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		-- Using this pattern example to scale buffer
		-- https://cpp.hotexamples.com/examples
		-- /-/-/cairo_pattern_create_for_surface/cpp-cairo_pattern_create_for_surface-function-examples.html
		do
			buffer.lock
			if buffer.is_locked
				and then attached {EL_DRAWABLE_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer
			then
				draw_scaled_surface (dimension, x, y, size, imp_buffer.cairo_context.surface)
				buffer.unlock
			end
		end

	draw_scaled_pixmap (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			l_surface: CAIRO_PIXEL_SURFACE_I
		do
			create {CAIRO_PIXEL_SURFACE_IMP} l_surface.make_with_scaled_pixmap (dimension, a_pixmap, a_size)
			draw_surface (x, y, l_surface)
			l_surface.destroy
		end

	draw_scaled_surface (dimension: NATURAL_8; x, y, size: DOUBLE; a_surface: CAIRO_SURFACE_I)
		-- Using this pattern example to scale surface
		-- https://cpp.hotexamples.com/examples
		-- /-/-/cairo_pattern_create_for_surface/cpp-cairo_pattern_create_for_surface-function-examples.html
		local
			pattern: CAIRO_PATTERN; proportion: DOUBLE; matrix: CAIRO_MATRIX
		do
			if dimension = By_width then
				proportion := size / a_surface.width
			else
				proportion := size / a_surface.height
			end
			create matrix.make_scaled (proportion, proportion)

			save
			create pattern.make (a_surface)
			pattern.set_matrix (matrix)
			pattern.set_filter (Cairo.Filter_best)
			translate (x, y)
			set_source_pattern (pattern)
			fill_rectangle (0, 0, a_surface.width * proportion, a_surface.height * proportion)
			restore
		end

	draw_surface (x, y: DOUBLE; source: CAIRO_SURFACE_I)
		do
			set_source_surface (source, x, y)
			Cairo.set_antialias (context, Cairo.Antialias_best)
			paint
			restore_color -- Need to restore color after set_source_surface
		end

	fill_concave_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		local
			x, y, corner, i: INTEGER
		do
			from i := 1 until i > 4 loop
				corner := All_corners [i]
				if (corner & corners_bitmap).to_boolean then
					inspect corner
						when Top_left then
							x := 0; y := 0
						when Top_right then
							x := width - radius; y := 0
						when Bottom_right then
							x := width - radius; y := height - radius
						when Bottom_left then
							x := 0; y := height - radius
					else end
					set_clip_concave_corner (x, y, radius, corner)
					fill_rectangle (x, y, radius, radius)
					reset_clip
				end
				i := i + 1
			end
		end

	fill_convex_corner (x, y, radius, corner: INTEGER)
		require
			valid_corner: is_valid_corner (corner)
		do
			define_sub_path
			move_to (x, y)
			inspect corner
				when Top_left then
					arc (x, y, radius, 0, radians (90))
				when Top_right then
					arc (x, y, radius, radians (90), radians (180))
				when Bottom_right then
					arc (x, y, radius, radians (180), radians (270))
				when Bottom_left then
					arc (x, y, radius, radians (270), radians (360))
			else end
			close_sub_path
			fill
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		local
			x, y, corner, i: INTEGER
		do
			from i := 1 until i > 4 loop
				corner := All_corners [i]
				if (corner & corners_bitmap).to_boolean then
					inspect corner
						when Top_left then
							x := 0; y := 0
						when Top_right then
							x := width; y := 0
						when Bottom_right then
							x := width; y := height
						when Bottom_left then
							x := 0; y := height
					else end
					fill_convex_corner (x, y, radius, corner)
				end
				i := i + 1
			end
		end

	fill_rectangle (x, y, a_width, a_height: DOUBLE)
		do
			Cairo.rectangle (context, x, y, a_width, a_height)
			Cairo.fill (context)
		end

feature {NONE} -- Alternative methods

	draw_scaled_pixel_buffer_alternative (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		-- alternative way to implement `draw_scaled_pixel_buffer' using scaled pattern
		-- Which is better? not sure.
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			factor: DOUBLE
		do
			save
			if dimension = By_width then
				factor := a_size / a_buffer.width
			else
				factor := a_size / a_buffer.height
			end
			scale_by (factor)
			draw_pixel_buffer (x / factor, y / factor, a_buffer)
			restore
		end

	draw_scaled_pixmap_alternative (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EV_PIXMAP)
		-- alternative way to implement `draw_scaled_pixmap' using scaled pattern
		-- Seems to produce identical results when screenshot inspected in image viewer
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			factor: DOUBLE
		do
			save
			if dimension = By_width then
				factor := a_size / a_pixmap.width
			else
				factor := a_size / a_pixmap.height
			end
			scale_by (factor)
			draw_pixmap ((x / factor).rounded, (y / factor).rounded, a_pixmap)
			restore
		end

	draw_scaled_pixmap_alternative_2 (dimension: NATURAL_8; x, y, a_size: DOUBLE; a_pixmap: EV_PIXMAP)
		require
			valid_dimension: is_valid_dimension (dimension)
		local
			l_surface: CAIRO_PIXEL_SURFACE_I
		do
			create {CAIRO_PIXEL_SURFACE_IMP} l_surface.make_with_pixmap (a_pixmap)
			draw_scaled_surface (dimension, x, y, a_size, l_surface)
			l_surface.destroy
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
			--
		do
			Cairo.destroy (this)
		end

	restore_color
		do
			set_color (color)
		end

	set_source_color
		deferred
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I, CAIRO_DRAWABLE_CONTEXT_I, EL_PIXEL_BUFFER_I} -- Internal attributes

	surface: CAIRO_SURFACE_I

end
