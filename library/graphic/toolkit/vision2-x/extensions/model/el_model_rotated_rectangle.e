note
	description: "Model rotated rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 17:27:21 GMT (Wednesday 29th May 2019)"
	revision: "3"

class
	EL_MODEL_ROTATED_RECTANGLE

inherit
	EV_MODEL_PARALLELOGRAM
		export
			{EV_MODEL} center, set_center
		end

	EL_MODEL_MATH
		undefine
			default_create
		end

	EL_ORIENTATION_CONSTANTS
		rename
			Top_left as Top_left_corner
		undefine
			default_create
		end

create
	make, make_with_coordinates, make_from_other

convert
	make ({EL_RECTANGLE})

feature {NONE} -- Initialization

	make (rect: EL_RECTANGLE)
		do
			make_with_coordinates (rect.to_point_array)
		end

	make_from_other (other: EL_MODEL_ROTATED_RECTANGLE)
		do
			make_with_coordinates (other.point_array)
		end

	make_with_coordinates (a_points: EL_COORDINATE_ARRAY)
		do
			default_create
			a_points.copy_to (point_array)
			set_center
		end

feature -- Access

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

	width_precise: DOUBLE
			-- The `width' of the parallelogram.
		do
			Result := point_distance (point_array.item (0), point_array.item (1))
		ensure
			width_positive: width >= Result.zero
		end

	coordinate_array: EL_COORDINATE_ARRAY
		do
			Result := point_array
		end

	circumscribed_square (side: INTEGER): EL_MODEL_ROTATED_RECTANGLE
		-- unrotated square inside a circle inside the square indicated by `side'
		require
			valid_side: is_valid_side (side)
			valid_horizontal_side: is_horizontal_side (side) implies height >= width
			valid_vertical_side: is_vertical_side (side) implies width >= height
		local
			alpha, diameter, l_angle: DOUBLE; i: INTEGER
			points: like point_array
		do
			diameter := width_precise; l_angle := angle
			create Result.make_from_other (Current)
			points := Result.point_array
			inspect side
				when Top then
					points [3] := point_on_circle (point_array [0], l_angle + radians (90), diameter)
					points [2] := point_on_circle (point_array [1], l_angle + radians (90), diameter)
				when Bottom then
					points [0] := point_on_circle (point_array [3], l_angle - radians (90), diameter)
					points [1] := point_on_circle (point_array [2], l_angle - radians (90), diameter)
				when Left then
					points [1] := point_on_circle (point_array [0], l_angle, diameter)
					points [2] := point_on_circle (point_array [3], l_angle, diameter)
				when Right then
					points [0] := point_on_circle (point_array [1], l_angle - radians (180), diameter)
					points [3] := point_on_circle (point_array [2], l_angle - radians (180), diameter)
			else
			end
			Result.set_center
			from i := 0; alpha := radians (135).opposite until i = 4 loop
				points [i] := point_on_circle (Result.center, l_angle + alpha, diameter / 2)
				i := i + 1
				alpha := alpha + radians (90)
			end
		end

feature -- Basic operations

	copy_coordinates_to (target: EV_MODEL)
		do
			coordinate_array.copy_to (target.point_array)
		end

	displace (a_distance, a_angle: DOUBLE)
		local
			a_delta_y, a_delta_x, alpha: DOUBLE
			points: like point_array
			l_coordinate: EV_COORDINATE
			i, nb: INTEGER
		do
			alpha := angle + a_angle
			points := point_array

			a_delta_x := cosine (alpha) * a_distance
			a_delta_y := sine (alpha) * a_distance

			if a_delta_y /= a_delta_y.zero or a_delta_x /= a_delta_x.zero then
				from
					i := 0
					nb := points.count - 1
				until
					i > nb
				loop
					l_coordinate := points.item (i)
					l_coordinate.set_precise (l_coordinate.x_precise + a_delta_x, l_coordinate.y_precise + a_delta_y)
					i := i + 1
				end
			end
			set_center
		end

	move_to_center (other: EL_MODEL_ROTATED_RECTANGLE)
		do
			set_x_y_precise (other.center)
		end

	set_x_y_precise (a_center: EV_COORDINATE)
		local
			a_delta_y, a_delta_x: DOUBLE; i, nb: INTEGER
			l_point_array: SPECIAL [EV_COORDINATE]; l_coordinate: EV_COORDINATE
		do
			a_delta_y := a_center.y_precise - center.y_precise
			a_delta_x := a_center.x_precise - center.x_precise
			if a_delta_y /= a_delta_y.zero or a_delta_x /= a_delta_x.zero then
				l_point_array := point_array
				from
					i := 0
					nb := l_point_array.count - 1
				until
					i > nb
				loop
					l_coordinate := l_point_array.item (i)
					l_coordinate.set_precise (l_coordinate.x_precise + a_delta_x, l_coordinate.y_precise + a_delta_y)
					i := i + 1
				end
				if is_in_group and then attached group as l_group and then l_group.is_center_valid then
					l_group.center_invalidate
				end
				center.set_precise (a_center.x_precise, a_center.y_precise)
				invalidate
			end
		end

	rotate_around_other (a_angle: DOUBLE; other: EL_MODEL_ROTATED_RECTANGLE)
			-- Rotate around center of `other' rectangle by `a_angle'.
		require
			is_rotatable: is_rotatable
		do
			projection_matrix.rotate (a_angle, other.center.x_precise, other.center.y_precise)
			recursive_transform (projection_matrix)
			set_center
			is_center_valid := True
		ensure
			center_valid: is_center_valid
		end

end
