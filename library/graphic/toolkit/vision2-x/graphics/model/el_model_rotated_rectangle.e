note
	description: "Model rotated rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "19"

class
	EL_MODEL_ROTATED_RECTANGLE

inherit
	EV_MODEL_PARALLELOGRAM
		rename
			modulo as modulo_double
		export
			{EV_MODEL} center, set_center
		undefine
			copy, is_equal, Default_pixmaps
		end

	EL_MODEL
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

	make_rotated (a_width, a_height: INTEGER; a_angle: DOUBLE)
		do
			make_rectangle (0, 0, a_width, a_height)
			rotate_around (a_angle, 0, 0)
		end

	make_rotated_cms (width_cms, height_cms: REAL; a_angle: DOUBLE)
		do
			make_rotated (Screen.horizontal_pixels (width_cms), Screen.vertical_pixels (height_cms), a_angle)
		end

	make_with_coordinates (a_points: EL_COORDINATE_ARRAY)
		do
			default_create
			a_points.copy_to (point_array)
			set_center
		end

feature -- Access

	bottom_most_line: EL_MODEL_LINE
		do
			Result := utmost_line (False)
		end

	center_line_points (axis: INTEGER): EL_COORDINATE_ARRAY
		do
			create Result.make (2)
			if not is_center_valid then
				set_center
			end
			inspect axis
				when {EL_DIRECTION}.X_axis then
					set_point_on_circle (Result.p0, center, angle, width_precise / 2)
					set_point_on_circle (Result.p1, center, angle + radians (180), width_precise / 2)

				when {EL_DIRECTION}.Y_axis then
					set_point_on_circle (Result.p0, center, angle - radians (90), height_precise / 2)
					set_point_on_circle (Result.p1, center, angle + radians (90), height_precise / 2)
			else end
		end

	direction_lines: ARRAYED_LIST [EL_MODEL_LINE]
		-- 3 parallel lines going from center line to edge for each of 4 directions
		local
			i, j: INTEGER; c, mp: EV_COORDINATE; p: SPECIAL [EV_COORDINATE]
		do
			create Result.make (4)
			c := center
			create p.make_filled (point_array [0], 4)
			from i := 0 until i > 3 loop
				from j := 0 until j > 3 loop
--					j - 1 => -1 |..| 2
					p [j] := point_i_th (i + j - 1) -- circular indexing
					j := j + 1
				end
				mp := mid_point (p [0], p [1])
				Result.extend (new_line (mp, p [1]))

				mp := mid_point (p [1], p [2])
				Result.extend (new_line (c, mp))

				mp := mid_point (p [2], p [3])
				Result.extend (new_line (mp, p [2]))
				i := i + 1
			end
		ensure
			three_by_four: Result.count = 12
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
				set_point_on_circle (Result.item (i), center, corner_angle (Orientation.clockwise_corners [i + 1]), l_radius)
				i := i + 1
			end
		end

	top_most_line: EL_MODEL_LINE
		do
			Result := utmost_line (True)
		end

feature -- Measurement

	angle_to_center (p: EV_COORDINATE): DOUBLE
		do
			Result := point_angle (p, center)
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

	radius: DOUBLE
		do
			Result := point_distance (center, point_array.item (0))
		end

	shorter_dimension: DOUBLE
		do
			Result := height_precise.min (width_precise)
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

	scale_to_circle (a_radius: DOUBLE)
		-- scale to fit inside circle with radius `a_radius'
		do
			scale (a_radius / radius)
		end

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

feature {NONE} -- Implementation

	utmost_line (a_top_most: BOOLEAN): EL_MODEL_LINE
		-- line with center point closest to top (or bottom if `a_top_most' is False)
		local
			i, index: INTEGER; utmost_distance, l_distance: DOUBLE
			p1, p2: EV_COORDINATE
		do
			from i := 0 until i = 3 loop
				p1 := point_array [i]; p2 := point_array [i + 1]
				if i = 0 then
					utmost_distance := mid_point (p1, p2).y_precise
				else
					l_distance := mid_point (p1, p2).y_precise
					if a_top_most then
						if l_distance < utmost_distance then
							utmost_distance := l_distance
							index := i
						end
					elseif l_distance > utmost_distance then
						utmost_distance := l_distance
						index := i
					end
				end
				i := i + 1
			end
			create Result.make_with_points (point_array [index], point_array [index + 1])
			Result.set_center
		end

end