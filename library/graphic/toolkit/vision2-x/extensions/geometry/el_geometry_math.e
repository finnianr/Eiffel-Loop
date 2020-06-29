note
	description: "Geometry math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-27 10:17:40 GMT (Saturday 27th June 2020)"
	revision: "12"

class
	EL_GEOMETRY_MATH

inherit
	EV_MODEL_DOUBLE_MATH

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_corner, is_valid_side, is_valid_axis
		end

feature {NONE} -- Implementation

	corner_angle (corner: INTEGER): DOUBLE
		require
			valid_corner: is_valid_corner (corner)
		do
			inspect corner
				when Top_left then
					Result := radians (135).opposite
				when Top_right then
					Result := radians (45).opposite
				when Bottom_right then
					Result := radians (45)
				when Bottom_left then
					Result := radians (135)
			else end
		end

	direction_angle (direction: INTEGER): DOUBLE
		require
			valid_corner: is_valid_side (direction)
		do
			inspect direction
				when Left then
					Result := radians (0)
				when Bottom then
					Result := radians (90)
				when Right then
					Result := radians (180)
				when Top then
					Result := radians (270)
			else end
		end

	degrees (a_radians: DOUBLE): INTEGER
		do
			Result := (360 * a_radians / (2 * Pi)).rounded \\ 360
		end

	degrees_plus_or_minus (a_radians: DOUBLE): INTEGER
		do
			Result := degrees (a_radians)
			if Result > 180 then
				Result := Result - 360
			end
		end

	is_point_in_circle (p, center: EV_COORDINATE; radius: DOUBLE): BOOLEAN
		-- `True' if point `p' is inside circle with `center' and `radius'
		do
			Result := point_distance (p, center) <= radius
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
				dx := dx / mag
				dy := dy / mag
			end
			pvx := p.x_precise - line_p1.x_precise
			pvy := p.y_precise - line_p1.y_precise

			-- Get dot product (project pv onto normalized direction)
			pvdot := dx * pvx + dy * pvy

			-- Scale line direction vector and subtract it from pv
			ax := pvx - pvdot * dx
			ay := pvy - pvdot * dy

			Result := sqrt (ax * ax + ay * ay)
		end

	mid_point (p1, p2: EV_COORDINATE): EV_COORDINATE
		do
			create Result.make_precise ((p1.x_precise + p2.x_precise) / 2, (p1.y_precise + p2.y_precise) / 2)
		end

	point_angle (p1, p2: EV_COORDINATE): DOUBLE
		do
			Result := line_angle (p1.x_precise, p1.y_precise, p2.x_precise, p2.y_precise)
		end

	point_distance (p1, p2: EV_COORDINATE): DOUBLE
		do
			Result := sqrt ((p1.x_precise - p2.x_precise) ^ 2 + (p1.y_precise - p2.y_precise) ^ 2)
		end

	point_on_circle (center: EV_COORDINATE; angle, radius: DOUBLE): EV_COORDINATE
		do
			create Result
			set_point_on_circle (Result, center, angle, radius)
		end

	positive_angle (alpha: DOUBLE): DOUBLE
		do
			if alpha <  Result.zero then
				Result := alpha + radians (360)
			else
				Result := alpha
			end
		end

	radians (a_degrees: INTEGER): DOUBLE
		do
			Result := a_degrees * Pi / 180
		end

	set_point_on_circle (point, center: EV_COORDINATE; angle, radius: DOUBLE)
		do
			point.set_precise (center.x_precise + cosine (angle) * radius, center.y_precise + sine (angle) * radius)
		end

end
