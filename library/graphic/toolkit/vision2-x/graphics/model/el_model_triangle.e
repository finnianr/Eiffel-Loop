note
	description: "Model triangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-11 9:48:43 GMT (Monday 11th March 2024)"
	revision: "8"

class
	EL_MODEL_TRIANGLE

inherit
	EV_MODEL_POLYGON
		rename
			modulo as modulo_double,
			Pi as Radian_180,
			Pi_2 as Radian_90,
			Pi_4 as Radian_45
		undefine
			copy, is_equal, Default_pixmaps
		redefine
			default_create
		end

	EL_MODEL

create
	default_create, make_right_angled

feature {NONE} -- Initialization

	default_create
			-- Polygon with no points.
		local
			triangle: EL_TRIANGLE_POINT_ARRAY
		do
			Precursor
			create triangle.make
			point_array := triangle.area
		end

	make_right_angled (apex: EV_COORDINATE; a_angle, size: DOUBLE)
		local
			i: INTEGER
		do
			default_create
			if attached point_array as p then
				from i := 0 until i > 2 loop
					set_point_on_circle (p [i], apex, a_angle + Radian_90 * (i - 1), size)
					i := i + 1
				end
			end
		end

end