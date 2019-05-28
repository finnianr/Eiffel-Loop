note
	description: "Model rotated rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-25 21:24:27 GMT (Saturday 25th May 2019)"
	revision: "2"

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
			pa: like point_array
			p0, p3: EV_COORDINATE
		do
			pa := point_array
			p0 := pa.item (0)
			p3 := pa.item (3)
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

feature -- Basic operations

	copy_coordinates_to (target: EV_MODEL)
		do
			coordinate_array.copy_to (target.point_array)
		end

	displace (a_distance, a_angle: DOUBLE)
		local
			a_delta_y, a_delta_x, alpha: DOUBLE
			pa: like point_array
			l_coordinate: EV_COORDINATE
			i, nb: INTEGER
		do
			alpha := angle + a_angle
			pa := point_array

			a_delta_x := cosine (alpha) * a_distance
			a_delta_y := sine (alpha) * a_distance

			if a_delta_y /= a_delta_y.zero or a_delta_x /= a_delta_x.zero then
				from
					i := 0
					nb := pa.count - 1
				until
					i > nb
				loop
					l_coordinate := pa.item (i)
					l_coordinate.set_precise (l_coordinate.x_precise + a_delta_x, l_coordinate.y_precise + a_delta_y)
					i := i + 1
				end
			end
			set_center
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
