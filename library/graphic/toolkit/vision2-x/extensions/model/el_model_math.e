note
	description: "Model math"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-28 14:20:01 GMT (Tuesday 28th May 2019)"
	revision: "2"

class
	EL_MODEL_MATH

inherit
	DOUBLE_MATH

feature {NONE} -- Implementation

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

	radians (degrees: INTEGER): DOUBLE
		do
			Result := degrees * Pi / 180
		end

end
