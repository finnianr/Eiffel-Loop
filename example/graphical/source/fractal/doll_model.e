note
	description: "Doll model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-28 15:09:41 GMT (Tuesday 28th May 2019)"
	revision: "1"

deferred class
	DOLL_MODEL

inherit
	EL_MODEL_ROTATED_RECTANGLE
		rename
			make as make_from_rectangle
		redefine
			project, recursive_transform
		end

	EL_MODEL_MATH
		undefine
			default_create
		end

	EL_MODULE_COLOR
		undefine
			default_create
		end

	COLOR_CONSTANTS
		undefine
			default_create
		end

	EL_MODULE_IMAGE
		undefine
			default_create
		end

	EL_ORIENTATION_CONSTANTS
		rename
			Top_left as Top_left_corner
		undefine
			default_create
		end

feature {NONE} -- Initialization

	make (rectangle: EL_MODEL_ROTATED_RECTANGLE)
		local
			alpha, diameter, l_angle: DOUBLE; l_center: EV_COORDINATE
			points: EL_COORDINATE_ARRAY; i: INTEGER
		do
			diameter := rectangle.width_precise
			alpha := rectangle.angle; l_angle := alpha
			make_from_other (rectangle)

			set_point_array (rectangle, alpha, diameter)
			set_center

			l_center := center
			-- points in circumscribed square
			create points.make (4)
			from i := 0; alpha := radians (135).opposite until i = 4 loop
				points [i] := point_on_circle (l_center, l_angle + alpha, diameter / 2)
				i := i + 1
				alpha := alpha + radians (90)
			end
			make_with_coordinates (points)
		end

feature -- Visitor

	project (a_projector: EV_MODEL_DRAWING_ROUTINES)
			-- <Precursor>
		do
--			set_center
			a_projector.draw_figure_picture (new_picture (point_on_circle (center, radians (180 + 45), radius)))
--			a_projector.draw_figure_picture (picture_model)
--			a_projector.draw_figure_parallelogram (Current)
		end

feature -- Element change

	recursive_transform (a_transformation: EV_MODEL_TRANSFORMATION)
		do
			Precursor (a_transformation)
			set_center
		end

feature {NONE} -- Implementation

	pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER
		deferred
		end

	pixmap_table: HASH_TABLE [EV_PIXMAP, INTEGER_64]
		deferred
		end

	set_point_array (rectangle: EL_MODEL_ROTATED_RECTANGLE; alpha, diameter: DOUBLE)
		deferred
		end

feature {NONE} -- Factory

	new_picture (a_center: EV_COORDINATE): EV_MODEL_PICTURE
		do
			create Result.make_with_pixmap (new_pixmap (angle, width))
			Result.set_point_position (a_center.x, a_center.y)
		end

	new_pixels_buffer (a_width: INTEGER): EL_DRAWABLE_PIXEL_BUFFER
		do
			create Result.make_with_size (a_width, a_width)
			Result.set_color (Color_placeholder)
			Result.fill
		end

	new_pixmap (alpha: DOUBLE; a_width: INTEGER): EV_PIXMAP
		-- pixmap rotated and scaled
		local
			pixels: EL_DRAWABLE_PIXEL_BUFFER
			pixmap_id: INTEGER_64; half_width: DOUBLE
		do
			pixmap_id := a_width.to_integer_64 |<< 32 | (positive_angle (alpha) * Angle_multiplier).truncated_to_integer

			if pixmap_table.has_key (pixmap_id) then
				Result := pixmap_table.found_item
			else
				pixels := new_pixels_buffer (a_width)

				half_width := width_precise / 2
				pixels.translate (half_width, half_width)
				pixels.rotate (alpha)
				pixels.translate (half_width.opposite, half_width.opposite)
				pixels.draw_scaled_pixel_buffer (0, 0, a_width, By_width, pixel_buffer)

				Result := pixels.to_pixmap
				pixmap_table.extend (Result, pixmap_id)
			end
		end

feature {NONE} -- Constants

	Angle_multiplier: DOUBLE
		local
			natural: NATURAL
		once
			Result := natural.Max_value / 10.0
		end

end
