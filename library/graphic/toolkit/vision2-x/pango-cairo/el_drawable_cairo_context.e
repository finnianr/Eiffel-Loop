note
	description: "Drawable Cairo context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:08:01 GMT (Monday 13th July 2020)"
	revision: "3"

deferred class
	EL_DRAWABLE_CAIRO_CONTEXT

inherit
	EL_OWNED_C_OBJECT
		rename
			self_ptr as context
		export
			{EL_DRAWABLE_PIXEL_BUFFER_I, EL_SVG_IMAGE, EL_DRAWABLE_CAIRO_CONTEXT} context
		end

	EL_CAIRO_COMMAND_CONTEXT

	EV_ANY_HANDLER

	EL_GEOMETRY_MATH
		export
			{NONE} all
			{ANY} is_valid_corner
		end

	EL_CAIRO_CONSTANTS

feature {NONE} -- Initialization

	make (a_surface: EL_CAIRO_SURFACE_I)
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
		local
			file_out: EL_PNG_IMAGE_FILE
		do
			create file_out.make_open_write (file_path)
			file_out.put_image (surface.self_ptr)
			file_out.close
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

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		do
			Cairo.translate (context, x, y)
		end

feature -- Status change

	set_antialias_best
		do
			Cairo.set_antialias (context, Cairo_antialias_best)
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

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap: INTEGER)
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

	set_source_surface (a_surface: EL_CAIRO_SURFACE_I; x, y: DOUBLE)
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
				Cairo.set_antialias (context, Cairo_antialias_none)
			end
			line_to (x2, y2)
			stroke
			if rotation_angle = rotation_angle.zero then
				Cairo.set_antialias (context, l_antialias)
			end
		end

	draw_pixel_buffer (x, y: INTEGER; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			if attached buffer.implementation as l_buffer then
				set_source_surface (l_buffer.cairo_context.surface, x, y)
				Cairo.set_antialias (context, Cairo_antialias_best)
				paint
				restore_color -- Need to restore color after set_source_surface
			end
		end

	draw_pixmap (x, y: INTEGER; pixmap: EV_PIXMAP)
		local
			source: EL_CAIRO_PIXMAP_SURFACE_I
		do
			create {EL_CAIRO_PIXMAP_SURFACE_IMP} source.make (pixmap)
			set_source_surface (source, x, y)
			Cairo.set_antialias (context, Cairo_antialias_best)
			paint
			restore_color -- Need to restore color after set_source_surface
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		local
			l_antialias: INTEGER
		do
			Cairo.rectangle (context, x + 1, y + 1, a_width, a_height)
			if rotation_angle = rotation_angle.zero then
				l_antialias := Cairo.antialias (context)
				Cairo.set_antialias (context, Cairo_antialias_none)
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

	draw_rounded_pixel_buffer (x, y, radius, corners_bitmap: INTEGER; buffer: EL_DRAWABLE_PIXEL_BUFFER)
		do
			set_clip_rounded_rectangle (x, y, buffer.width, buffer.height, radius, corners_bitmap)
			draw_pixel_buffer (x, y, buffer)
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

	fill_rectangle (x, y, a_width, a_height: INTEGER)
		do
			Cairo.rectangle (context, x, y, a_width, a_height)
			Cairo.fill (context)
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

feature {EL_DRAWABLE_PIXEL_BUFFER_I, EL_DRAWABLE_CAIRO_CONTEXT} -- Internal attributes

	surface: EL_CAIRO_SURFACE_I

end