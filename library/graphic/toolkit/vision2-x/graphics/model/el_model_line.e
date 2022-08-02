note
	description: "Model line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-01 10:11:17 GMT (Monday 1st August 2022)"
	revision: "6"

class
	EL_MODEL_LINE

inherit
	EV_MODEL_LINE
		export
			{EV_MODEL} set_center
		undefine
			copy, Default_pixmaps
		redefine
			angle --, make_with_points
		end

	EL_MODEL
		rename
			perpendicular_distance as perpendicular_distance_to_line
		end

create
	default_create, make_with_positions, make_with_points

feature -- Access

	p0: EV_COORDINATE
		do
			Result := point_array [0]
		end

	p1: EV_COORDINATE
		do
			Result := point_array [1]
		end

feature -- Measurement

	angle: DOUBLE
			-- actually we do care!
		do
			Result := point_angle (p0, p1)
		end

	length_precise: DOUBLE
		do
			Result := point_distance (p0, p1)
		end

	normal_angle: DOUBLE
		-- normalized acute angle
		do
			if point_array.item (0).x_precise <= point_array.item (1).x_precise then
				Result := point_angle (p0, p1)
			else
				Result := point_angle (p1, p0)
			end
			if Result > Pi then
				Result := Result - 2 * Pi
			end
		end

	perpendicular_distance (p: EV_COORDINATE): DOUBLE
		do
			Result := perpendicular_distance_to_line (p, p0, p1)
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

feature -- Element change

	grow (delta: DOUBLE)
		-- grow line by `delta' in the direction of `point_b'
		do
			set_point_on_circle (p1, p0, angle, length_precise + delta)
		end

feature {NONE} -- Implementation

	cross_product (p: EV_COORDINATE): DOUBLE
		local
			a, b: EV_COORDINATE; a_x, a_y: DOUBLE
		do
			a := p0; b := p1
			a_x := a.x_precise; a_y := a.y_precise
			Result := (b.x_precise - a_x) * (p.y_precise - a_y) - (b.y_precise - a_y) * (p.x_precise - a_x)
		end

end