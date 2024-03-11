note
	description: "Model line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-11 9:51:12 GMT (Monday 11th March 2024)"
	revision: "10"

class
	EL_MODEL_LINE

inherit
	EV_MODEL_LINE
		rename
			modulo as modulo_double,
			Pi as Radian_180,
			Pi_2 as Radian_90,
			Pi_4 as Radian_45
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
			if attached point_array as p then
				Result := point_angle (p [0], p [1])
			end
		end

	length_precise: DOUBLE
		do
			if attached point_array as p then
				Result := point_distance (p [0], p [1])
			end
		end

	normal_angle: DOUBLE
		-- normalized acute angle
		do
			if attached point_array as p then
				if p [0].x_precise <= p [1].x_precise then
					Result := point_angle (p [0], p [1])
				else
					Result := point_angle (p [1], p [0])
				end
			end
			if Result > Radian_180 then
				Result := Result - 2 * Radian_180
			end
		end

	perpendicular_distance (point: EV_COORDINATE): DOUBLE
		do
			if attached point_array as p then
				Result := perpendicular_distance_to_line (point, p [0], p [1])
			end
		end

feature -- Status query

	is_left (point: EV_COORDINATE): BOOLEAN
		do
			Result := cross_product (point) > 0
		end

	is_right (point: EV_COORDINATE): BOOLEAN
		do
			Result := cross_product (point) < 0
		end

feature -- Element change

	grow (delta: DOUBLE)
		-- grow line by `delta' in the direction of `point_b'
		do
			if attached point_array as p then
				set_point_on_circle (p [1], p [0], angle, length_precise + delta)
			end
		end

feature {NONE} -- Implementation

	cross_product (point: EV_COORDINATE): DOUBLE
		local
			a, b: EV_COORDINATE; a_x, a_y: DOUBLE
		do
			if attached point_array as p then
				a := p [0]; b := p [1]
			end
			a_x := a.x_precise; a_y := a.y_precise
			Result := (b.x_precise - a_x) * (point.y_precise - a_y) - (b.y_precise - a_y) * (point.x_precise - a_x)
		end

end