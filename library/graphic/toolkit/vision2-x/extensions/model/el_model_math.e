note
	description: "Model math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-13 12:08:21 GMT (Thursday 13th June 2019)"
	revision: "5"

class
	EL_MODEL_MATH

inherit
	DOUBLE_MATH
		export
			{NONE} all
		end

	EL_ORIENTATION_ROUTINES

feature {NONE} -- Implementation

	degrees (a_radians: DOUBLE): INTEGER
		do
			Result := (360 * a_radians / (2 * Pi)).rounded
		end

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

	positive_angle (alpha: DOUBLE): DOUBLE
		do
			if alpha <  Result.zero then
				Result := alpha + radians (360)
			else
				Result := alpha
			end
		end

	point_distance (p1, p2: EV_COORDINATE): DOUBLE
		do
			Result := sqrt ((p1.x_precise - p2.x_precise) ^ 2 + (p1.y_precise - p2.y_precise) ^ 2)
		end

	point_on_circle (center: EV_COORDINATE; angle, radius: DOUBLE): EV_COORDINATE
		do
			create Result.make_precise (center.x_precise + cosine (angle) * radius, center.y_precise + sine (angle) * radius)
		end

	radians (a_degrees: INTEGER): DOUBLE
		do
			Result := a_degrees * Pi / 180
		end

end
