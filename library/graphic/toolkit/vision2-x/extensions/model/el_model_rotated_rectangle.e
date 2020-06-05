note
	description: "Model rotated rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-04 8:16:34 GMT (Thursday 4th June 2020)"
	revision: "7"

class
	EL_MODEL_ROTATED_RECTANGLE

inherit
	EV_MODEL_PARALLELOGRAM
		export
			{EV_MODEL} center, set_center
		end

	EL_MODEL_MATH
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
			default_create
			set_coordinates_from (other)
		end

	make_with_coordinates (a_points: EL_COORDINATE_ARRAY)
		do
			default_create
			a_points.copy_to (point_array)
			set_center
		end

feature -- Access

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

	outer_radial_square_coordinates: EL_COORDINATE_ARRAY
		-- coordinates of square that encloses circle circumscribing `Current'
		local
			i: INTEGER; alpha, l_radius: DOUBLE
			p_top: EV_COORDINATE
		do
			alpha := angle
			p_top := point_on_circle (center, alpha - radians (90), radius)
			l_radius := point_distance (center, point_on_circle (p_top, alpha, radius))
			create Result.make (4)
			from i := 0 until i = 4 loop
				set_point_on_circle (Result.item (i), center, corner_angle (All_corners [i + 1]), l_radius)
				i := i + 1
			end
		end

	angle_to_center (p: EV_COORDINATE): DOUBLE
		do
			Result := point_angle (p, center)
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

	set_coordinates_from (other: EV_MODEL)
		require
			equal_point_count: point_count = other.point_count
		local
			i: INTEGER
		do
			from i := 0 until i = point_array.count loop
				point_array.item (i).copy (other.point_array [i])
				i := i + 1
			end
			set_center
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

	set_points (other: EL_MODEL_ROTATED_RECTANGLE)
		do
			set_coordinates_from (other)
		end

end
