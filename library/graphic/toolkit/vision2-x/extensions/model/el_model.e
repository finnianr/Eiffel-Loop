note
	description: "Model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-17 11:27:55 GMT (Wednesday 17th June 2020)"
	revision: "3"

deferred class
	EL_MODEL

inherit
	EV_MODEL
		export
			{ANY} center
		undefine
			bounding_box, default_create, point_count
		redefine
			copy, is_equal
		end

	EL_MODEL_MATH undefine copy, default_create, is_equal end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := point_array ~ other.point_array
		end

feature -- Conversion

	to_point_array: EL_COORDINATE_ARRAY
		do
			Result := point_array
		end

feature -- Duplication

	copy (other: like Current)
		do
			set_coordinates_from (other)
		end

	reflected (line: EL_MODEL_LINE): like Current
		do
			Result := twin
			Result.reflect (line)
		end

feature -- Basic operations

	move_in_direction (a_angle, a_distance: DOUBLE)
		-- move model by `a_distance' in direction of `a_angle'
		local
			a_delta_y, a_delta_x: DOUBLE; i, nb: INTEGER
			points: like point_array; p: EV_COORDINATE
		do
			points := point_array

			a_delta_x := cosine (a_angle) * a_distance
			a_delta_y := sine (a_angle) * a_distance

			if a_delta_y /= a_delta_y.zero or a_delta_x /= a_delta_x.zero then
				from i := 0; nb := points.count - 1 until i > nb loop
					p := points.item (i)
					p.set_precise (p.x_precise + a_delta_x, p.y_precise + a_delta_y)
					i := i + 1
				end
			end
			set_center
		end

	draw (canvas: EL_DRAWABLE)
		do
			canvas.draw_polyline (to_point_array, True)
		end

	move_to_center (other: EL_MODEL)
		do
			set_x_y_precise (other.center)
		end

feature -- Element change

	move (a_x, a_y: DOUBLE)
		local
			transformation: EV_MODEL_TRANSFORMATION
		do
			transformation := projection_matrix
			transformation.translate (a_x, a_y)
			transform (transformation)
			set_center
		end

	reflect (line: EL_MODEL_LINE)
		-- move and rotate model to be reflection on opposite side of line
		local
			orthogonal_angle, delta_angle, l_distance: DOUBLE; c: like center
		do
			c := center
			l_distance := line.perpendicular_distance (c)
			if line.is_left (c) then
				orthogonal_angle := line.angle - radians (90)
			else
				orthogonal_angle := line.angle + radians (90)
			end
			delta_angle := angle - line.angle
			move_in_direction (orthogonal_angle, l_distance * 2)
			rotate ((delta_angle * 2).opposite + Pi)
			set_center
			invalidate
		end

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
			invalidate
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

end
