note
	description: "Geometry math extending ${EV_MODEL_DOUBLE_MATH}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-11 10:07:53 GMT (Monday 11th March 2024)"
	revision: "17"

class
	EL_GEOMETRY_MATH

inherit
	EV_MODEL_DOUBLE_MATH
		rename
			Pi as Radian_180,
			Pi_2 as Radian_90,
			Pi_4 as Radian_45
		export
			{NONE} all
		end

	EL_MODULE_ORIENTATION

	EL_DIRECTION_CONSTANTS

feature {NONE} -- Radian angles

	corner_angle (corner: INTEGER): DOUBLE
		require
			valid_corner: Orientation.is_valid_corner (corner)
		do
			inspect corner
				when Top_left_corner then
					Result :=  3 * Radian_45.opposite
				when Top_right_corner then
					Result := Radian_45.opposite
				when Bottom_right_corner then
					Result := Radian_45
				when Bottom_left_corner then
					Result := 3 * Radian_45
			else end
		end

	point_angle (p1, p2: EV_COORDINATE): DOUBLE
		do
			Result := line_angle (p1.x_precise, p1.y_precise, p2.x_precise, p2.y_precise)
		end

	positive_angle (alpha: DOUBLE): DOUBLE
		do
			if alpha <  Result.zero then
				Result := alpha + 2 * Radian_180
			else
				Result := alpha
			end
		end

	radians (a_degrees: INTEGER): DOUBLE
		do
			Result := a_degrees * Radian_180 / 180
		end

feature {NONE} -- Degree angles

	degrees (a_radians: DOUBLE): INTEGER
		-- `a_radians' rounded to nearest degree <= 360
		do
			Result := (180 * a_radians / Radian_180).rounded \\ 360
		end

	degrees_plus_or_minus (a_radians: DOUBLE): INTEGER
		do
			Result := degrees (a_radians)
			if Result > 180 then
				Result := Result - 360
			end
		end

feature {NONE} -- Status query

	is_point_in_circle (p, center: EV_COORDINATE; radius: DOUBLE): BOOLEAN
		-- `True' if point `p' is inside circle with `center' and `radius'
		do
			Result := point_distance (p, center) <= radius
		end

feature {NONE} -- Measurement

	longer (width, height: INTEGER): TUPLE [dimension: NATURAL_8; size: INTEGER]
		-- longer side of two dimensions `a_width' and `'
		do
			if width >= height then
				Result := [By_width, width]
			else
				Result := [By_height, height]
			end
		end

	perpendicular_distance (p, line_p1, line_p2: EV_COORDINATE): DOUBLE
		-- perpendicular distance of point `p' to line defined by points `line_p1' and `line_p2'
		-- (See https://rosettacode.org/wiki/Ramer-Douglas-Peucker_line_simplification)
		local
			dx, dy, mag, pvx, pvy, pvdot, ax, ay: DOUBLE
		do
			dx := line_p2.x_precise - line_p1.x_precise
			dy := line_p2.y_precise - line_p1.y_precise
			-- Normalize
			mag := sqrt (dx * dx + dy * dy)
			if mag > mag.zero then
				dx := dx / mag; dy := dy / mag
			end
			pvx := p.x_precise - line_p1.x_precise
			pvy := p.y_precise - line_p1.y_precise

			-- Get dot product (project pv onto normalized direction)
			pvdot := dx * pvx + dy * pvy

			-- Scale line direction vector and subtract it from pv
			ax := pvx - pvdot * dx; ay := pvy - pvdot * dy

			Result := sqrt (ax * ax + ay * ay)
		end

	point_distance (p1, p2: EV_COORDINATE): DOUBLE
		local
			x_distance, y_distance: DOUBLE
		do
			x_distance := p1.x_precise - p2.x_precise
			y_distance := p1.y_precise - p2.y_precise
			Result := sqrt (x_distance * x_distance + y_distance * y_distance)
		end

feature {NONE} -- Position

	mid_point (p1, p2: EV_COORDINATE): EV_COORDINATE
		do
			create Result.make_precise ((p1.x_precise + p2.x_precise) / 2, (p1.y_precise + p2.y_precise) / 2)
		end

	point_on_circle (center: EV_COORDINATE; angle, radius: DOUBLE): EV_COORDINATE
		do
			create Result
			set_point_on_circle (Result, center, angle, radius)
		end

feature {NONE} -- Basic operations

	set_point_on_circle (point, center: EV_COORDINATE; angle, radius: DOUBLE)
		do
			point.set_precise (center.x_precise + cosine (angle) * radius, center.y_precise + sine (angle) * radius)
		end

end