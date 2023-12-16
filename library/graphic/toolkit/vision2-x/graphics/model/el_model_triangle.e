note
	description: "Model triangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-16 19:55:29 GMT (Saturday 16th December 2023)"
	revision: "6"

class
	EL_MODEL_TRIANGLE

inherit
	EV_MODEL_POLYGON
		rename
			modulo as modulo_double
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
			from i := 0 until i > 2 loop
				set_point_on_circle (point_array [i], apex, a_angle + radians (90 * (i - 1)), size)
				i := i + 1
			end
		end

end