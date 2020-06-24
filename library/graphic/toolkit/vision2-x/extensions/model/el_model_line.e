note
	description: "Model line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-24 16:51:20 GMT (Wednesday 24th June 2020)"
	revision: "4"

class
	EL_MODEL_LINE

inherit
	EV_MODEL_LINE
		export
			{EV_MODEL} set_center
		undefine
			copy
		redefine
			angle --, make_with_points
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

	normal_angle: DOUBLE
		-- normalized acute angle
		do
			if point_array.item (0).x_precise <= point_array.item (1).x_precise then
				Result := point_angle (point_array [0], point_array [1])
			else
				Result := point_angle (point_array [1], point_array [0])
			end
			if Result > Pi then
				Result := Result - 2 * Pi
			end
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
		local
			a, b: EV_COORDINATE; a_x, a_y: DOUBLE
		do
			a := point_array [0]; b := point_array [1]
			a_x := a.x_precise; a_y := a.y_precise
			Result := (b.x_precise - a_x) * (p.y_precise - a_y) - (b.y_precise - a_y) * (p.x_precise - a_x)
		end

end
