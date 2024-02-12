note
	description: "4 point array forming a rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-29 18:30:30 GMT (Monday 29th January 2024)"
	revision: "6"

class
	EL_RECTANGLE_POINT_ARRAY

inherit
	EL_TRIANGLE_POINT_ARRAY
		redefine
			point_count
		end

create
	make_from_area, make

convert
	make_from_area ({SPECIAL [EV_COORDINATE]})

feature -- Access

	center: EV_COORDINATE
		do
			if attached area as p then
				Result := mid_point (p [0], p [2])
			end
		end

	p3: EV_COORDINATE
		do
			Result := area [3]
		end

	point_count: INTEGER
		do
			Result := 4
		end

	inner_radius: DOUBLE
		-- radius of largest circle that fits inside center of rectangle
		do
			if attached area as p then
				if point_distance (p [0], p [1]) > point_distance (p [1], p [2]) then
					Result := point_distance (center, mid_point (p [0], p [1]))
				else
					Result := point_distance (center, mid_point (p [1], p [2]))
				end
			end
		end

feature -- Status query

	in_circle (point: EV_COORDINATE): BOOLEAN
		-- `True' if point in circumscribing circle
		local
			c: like center
		do
			c := center
			Result := point_distance (point, c) <= point_distance (area [0], c)
		end

	in_inner_circle (point: EV_COORDINATE): BOOLEAN
		-- `True' if point is inside inner circles
		do
			Result := point_distance (point, center) <= inner_radius
		end

end