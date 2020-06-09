note
	description: "Model line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-09 16:54:31 GMT (Tuesday 9th June 2020)"
	revision: "1"

class
	EL_MODEL_LINE

inherit
	EV_MODEL_LINE
		undefine
			copy, is_equal
		redefine
			angle
		end

	EL_MODEL
		rename
			perpendicular_distance as perpendicular_distance_to_line
		end

create
	default_create, make_with_positions, make_with_points

feature -- Measurement

	angle: DOUBLE
			-- actually we do care!
		do
			Result := point_angle (point_array [0], point_array [1])
		end

	perpendicular_distance (p: EV_COORDINATE): DOUBLE
		do
			Result := perpendicular_distance_to_line (p, point_array [0], point_array [1])
		end

feature -- Status query

	is_left (p: EV_COORDINATE): BOOLEAN
		do
			Result := cross_product (p) > 0
		end

	is_right (p: EV_COORDINATE): BOOLEAN
		do
			Result := cross_product (p) < 0
		end

feature {NONE} -- Implementation

	cross_product (p: EV_COORDINATE): DOUBLE
		do
			Result := (point_b_x - point_a_x) * (p.y_precise - point_a_y) - (point_b_y - point_a_y) * (p.x_precise - point_a_x)
		end

end
