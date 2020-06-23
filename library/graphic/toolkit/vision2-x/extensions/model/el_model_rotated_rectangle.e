note
	description: "Model rotated rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-23 12:06:12 GMT (Tuesday 23rd June 2020)"
	revision: "12"

class
	EL_MODEL_ROTATED_RECTANGLE

inherit
	EV_MODEL_PARALLELOGRAM
		export
			{EV_MODEL} center, set_center
		undefine
			copy, is_equal
		end

	EL_MODEL
		rename
			Top_left as Top_left_corner
		redefine
			to_point_array
		end

	EL_MODULE_SCREEN

create
	default_create, make, make_with_coordinates, make_rotated, make_rotated_cms

convert
	make ({EL_RECTANGLE})

feature {NONE} -- Initialization

	make (rect: EL_RECTANGLE)
		do
			make_with_coordinates (rect.to_point_array)
		end

	make_with_coordinates (a_points: EL_COORDINATE_ARRAY)
		do
			default_create
			a_points.copy_to (point_array)
			set_center
		end

	make_rotated (a_width, a_height: INTEGER; a_angle: DOUBLE)
		do
			make_rectangle (0, 0, a_width, a_height)
			rotate_around (a_angle, 0, 0)
		end

	make_rotated_cms (width_cms, height_cms: REAL; a_angle: DOUBLE)
		do
			make_rotated (Screen.horizontal_pixels (width_cms), Screen.vertical_pixels (height_cms), a_angle)
		end

feature -- Access

	angle_to_center (p: EV_COORDINATE): DOUBLE
		do
			Result := point_angle (p, center)
		end

	center_line_points (axis: INTEGER): EL_COORDINATE_ARRAY
		do
			create Result.make (2)
			if not is_center_valid then
				set_center
			end
			inspect axis
				when X_axis then
					set_point_on_circle (Result.p0, center, angle, width_precise / 2)
					set_point_on_circle (Result.p1, center, angle + radians (180), width_precise / 2)

				when Y_axis then
					set_point_on_circle (Result.p0, center, angle - radians (90), height_precise / 2)
					set_point_on_circle (Result.p1, center, angle + radians (90), height_precise / 2)
			else end
		end

	height_precise: DOUBLE
			-- The `height' of the parallelogram.
		local
			points: like point_array
			p0, p3: EV_COORDINATE
		do
			points := point_array
			p0 := points.item (0)
			p3 := points.item (3)
			Result := point_distance (p0, p3)
		ensure
			height_positive: height >= Result.zero
		end

	outer_radial_square_coordinates: EL_RECTANGLE_POINT_ARRAY
		-- coordinates of square that encloses circle circumscribing `Current'
		local
			i: INTEGER; alpha, l_radius: DOUBLE
			p_top: EV_COORDINATE
		do
			alpha := angle
			p_top := point_on_circle (center, alpha - radians (90), radius)
			l_radius := point_distance (center, point_on_circle (p_top, alpha, radius))
			create Result.make_default
			from i := 0 until i = 4 loop
				set_point_on_circle (Result.item (i), center, corner_angle (All_corners [i + 1]), l_radius)
				i := i + 1
			end
		end

	radius: DOUBLE
		do
			Result := point_distance (center, point_array.item (0))
		end

	width_precise: DOUBLE
			-- The `width' of the parallelogram.
		do
			Result := point_distance (point_array.item (0), point_array.item (1))
		ensure
			width_positive: width >= Result.zero
		end

feature -- Basic operations

	rotate_around_other (a_angle: DOUBLE; other: EL_MODEL_ROTATED_RECTANGLE)
			-- Rotate around center of `other' rectangle by `a_angle'.
		do
			rotate_around_point (a_angle, other.center)
		ensure
			center_valid: is_center_valid
		end

	rotate_around_point (an_angle: DOUBLE; point: EV_COORDINATE)
			-- Rotate around (`ax', `ay') for `an_angle'.
		do
			if not is_center_valid then
				set_center
			end
			projection_matrix.rotate (an_angle, point.x_precise, point.y_precise)
			recursive_transform (projection_matrix)
			is_center_valid := True
		ensure
			center_valid: is_center_valid
		end

feature -- Element change

	scale_to_fit (rectangle: EL_RECTANGLE; area_proportion, max_dimension_proportion: DOUBLE)
		-- scale model so that the model area is equal to `area_proportion' of `rectangle'
		-- but `max_dimension_proportion' is not exceeded for `width' or `height'
		local
			proportion: DOUBLE
		do
			proportion := {DOUBLE_MATH}.sqrt (rectangle.area * area_proportion / (height_precise * width_precise))

			if proportion * height_precise > rectangle.height * max_dimension_proportion then
				proportion := rectangle.height * max_dimension_proportion / height_precise

			elseif proportion * width_precise > rectangle.width * max_dimension_proportion then
				proportion := rectangle.width * max_dimension_proportion / width_precise
			end
			scale (proportion)
		ensure
			valid_area: (height_precise * width_precise).rounded <= (rectangle.area * area_proportion).rounded
			valid_height: height <= (rectangle.height * max_dimension_proportion).rounded
			valid_width: width <= (rectangle.width * max_dimension_proportion).rounded
		end

	scale_to_circle (a_radius: DOUBLE)
		-- scale to fit inside circle with radius `a_radius'
		do
			scale (a_radius / radius)
		end

	set_from_other (other: EL_MODEL_ROTATED_RECTANGLE)
		do
			set_coordinates_from (other)
		end

	set_points (other: EL_RECTANGLE_POINT_ARRAY)
		do
			other.copy_to (point_array)
			set_center
			invalidate
		end

feature -- Conversion

	to_point_array: EL_RECTANGLE_POINT_ARRAY
		do
			Result := point_array
		end

feature -- Conversion

	to_outline: EL_MODEL_ROTATED_RECTANGLE
		do
			create Result
			Result.set_coordinates_from (Current)
			Result.enable_dashed_line_style
		end

end
