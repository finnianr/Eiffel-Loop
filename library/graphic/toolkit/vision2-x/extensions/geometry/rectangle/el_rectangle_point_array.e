note
	description: "Rectangle point coordinate array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-07 20:40:43 GMT (Sunday 7th June 2020)"
	revision: "2"

class
	EL_RECTANGLE_POINT_ARRAY

inherit
	EL_TRIANGLE_POINT_ARRAY
		redefine
			line_count
		end

create
	make_from_area, make_default

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature -- Access

	center: EV_COORDINATE
		do
			Result := mid_point (p0, p2)
		end

	p3: EV_COORDINATE
		require
			valid_index: valid_index (3)
		do
			Result := item (3)
		end

	line_count: INTEGER
		do
			Result := 4
		end

	inner_radius: DOUBLE
		-- radius of largest circle that fits inside center of rectangle
		do
			if point_distance (p0, p1) > point_distance (p1, p2) then
				Result := point_distance (center, mid_point (p0, p1))
			else
				Result := point_distance (center, mid_point (p1, p2))
			end
		end

feature -- Status query

	in_circle (point: EV_COORDINATE): BOOLEAN
		-- `True' if point in circumscribing circle
		local
			c: like center
		do
			c := center
			Result := point_distance (point, c) <= point_distance (p0, c)
		end

	in_inner_circle (point: EV_COORDINATE): BOOLEAN
		-- `True' if point is inside inner circles
		do
			Result := point_distance (point, center) <= inner_radius
		end

end
