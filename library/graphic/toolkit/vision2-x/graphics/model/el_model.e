note
	description: "Extended [$source EV_MODEL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-16 20:22:30 GMT (Saturday 16th December 2023)"
	revision: "13"

deferred class
	EL_MODEL

inherit
	EV_MODEL
		rename
			modulo as modulo_double
		export
			{ANY} center
		undefine
			bounding_box, default_create, point_count, Default_pixmaps
		redefine
			copy
		end

	EL_GEOMETRY_MATH
		rename
			modulo as modulo_double
		undefine
			copy, default_create, is_equal
		end

	EL_SHARED_DEFAULT_PIXMAPS

	EL_INTEGER_MATH
		export
			{NONE} all
		undefine
			copy, default_create
		end

feature -- Access

	point_i_th (i: INTEGER): EV_COORDINATE
		--  `point_array [i]' using circular indexing
		-- so `point_i_th (point_count)' = `point_array [0]'
		do
			Result := point_array [modulo (i, point_count)]
		end

	furthest (direction: INTEGER): EV_COORDINATE
		-- furthest point in `direction'
		local
			i: INTEGER; exceeded: BOOLEAN
		do
			if attached point_array as p then
				Result := p [0]
				from i := 1 until i = point_count loop
					inspect direction
						when {EL_DIRECTION}.Top then
							exceeded := p [i].y_precise < Result.y_precise

						when {EL_DIRECTION}.Bottom then
							exceeded := p [i].y_precise > Result.y_precise

						when {EL_DIRECTION}.Left then
							exceeded := p [i].x_precise < Result.x_precise

						when {EL_DIRECTION}.Right then
							exceeded := p [i].x_precise > Result.x_precise
					else
						exceeded := False
					end
					if exceeded then
						Result := p [i]
					end
					i := i + 1
				end
			end
		end

feature -- Comparison

	same_points (other: like Current): BOOLEAN
		local
			i, n: INTEGER
		do
			if attached point_array as p and then attached other.point_array as p_o then
				Result := p.count = p_o.count
				if Result then
					n := p.count
					from i := 0 until not Result or else i = n loop
						Result := p [i] ~ p_o [i]
						i := i + 1
					end
				end
			end
		end

feature -- Conversion

	to_point_array: EL_POINT_ARRAY
		do
			Result := point_array
		end

feature -- Duplication

	copy (other: like Current)
		local
			l_array: EL_POINT_ARRAY
		do
			standard_copy (other)
			create l_array.make_filled (other.point_count)
			point_array := l_array.area
			copy_points (other.point_array)
			center := other.center.twin
		end

	reflected (line: EL_MODEL_LINE): like Current
		do
			Result := twin
			Result.reflect (line)
		end

feature -- Basic operations

	draw (canvas: EL_DRAWABLE)
		do
			canvas.draw_polyline (to_point_array, True)
		end

feature -- Transform

	move_in_direction (a_angle, a_distance: DOUBLE)
		-- move model by `a_distance' in direction of `a_angle'
		local
			a_delta_y, a_delta_x: DOUBLE; i, upper: INTEGER
			p: EV_COORDINATE
		do
			a_delta_x := cosine (a_angle) * a_distance
			a_delta_y := sine (a_angle) * a_distance

			if (a_delta_y /= a_delta_y.zero or a_delta_x /= a_delta_x.zero )
				and then attached point_array as area
			then
				upper := area.count - 1
				from i := 0 until i > upper loop
					p := area [i]
					p.set_precise (p.x_precise + a_delta_x, p.y_precise + a_delta_y)
					i := i + 1
				end
			end
			set_center
		end

	move_to_center (other: EL_MODEL)
		do
			set_x_y_precise (other.center)
		end

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

			set_center; invalidate
		end

	set_coordinates_from (other: EV_MODEL)
		require
			equal_point_count: point_count = other.point_count
		do
			copy_points (other.point_array)
			set_center; invalidate
		end

	set_x_y_precise (a_center: EV_COORDINATE)
		local
			a_delta_y, a_delta_x: DOUBLE; i, nb: INTEGER
			l_coordinate: EV_COORDINATE
		do
			a_delta_y := a_center.y_precise - center.y_precise
			a_delta_x := a_center.x_precise - center.x_precise
			if attached point_array as p and then (a_delta_y /= a_delta_y.zero or a_delta_x /= a_delta_x.zero) then
				from
					i := 0; nb := p.count - 1
				until
					i > nb
				loop
					l_coordinate := p [i]
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

feature {NONE} -- Implementation

	copy_points (other_array: like point_array)
		require
			same_size: point_count = other_array.count
		local
			i, upper: INTEGER
		do
			if attached point_array as p and then attached other_array as o_p then
				upper := p.count.min (o_p.count) - 1
				from i := 0 until i > upper loop
					p [i].copy (o_p [i])
					i := i + 1
				end
			end
		end

	new_line (p1, p2: EV_COORDINATE): EL_MODEL_LINE
		do
			create Result.make_with_points (p1, p2)
		end

end