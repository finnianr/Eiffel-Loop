note
	description: "Model math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-18 9:16:00 GMT (Thursday 18th July 2019)"
	revision: "7"

class
	EL_MODEL_MATH

inherit
	DOUBLE_MATH
		export
			{NONE} all
		end

	EL_ORIENTATION_ROUTINES

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

	distance_from_points (x, y: DOUBLE; p1, p2: EV_COORDINATE): DOUBLE
			-- Calculate distance between (`x', `y') and (`p1.x', `p1.y')-(`p2.x', `p2.y').
			-- The line is considered to be infinite.
		local
			dx, dy, alpha, beta, sine_theta, x_dist, y_dist: DOUBLE
		do
			dx := (x - p1.x).abs
			dy := (y - p1.y).abs
			alpha := arc_tangent ((p2.y - p1.y) / (p2.x - p1.x))
			beta := arc_tangent (dy / dx)
			sine_theta := sine (beta - alpha)
			x_dist := sine_theta * dx
			y_dist := sine_theta * dy
			Result := sqrt (x_dist ^ 2 + y_dist ^ 2)
		end

	mid_point (p1, p2: EV_COORDINATE): EV_COORDINATE
		do
			create Result.make_precise ((p1.x_precise + p2.x_precise) / 2, (p1.y_precise + p2.y_precise) / 2)
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
