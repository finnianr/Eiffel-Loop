note
	description: "Model triangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

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
		do
			Precursor
			create point_array.make_empty (3)
			from until point_array.count = 3 loop
				point_array.extend (create {EV_COORDINATE})
			end
		end

	make_right_angled (apex: EV_COORDINATE; a_angle, size: DOUBLE)
		do
			default_create
			across -1 |..| 1 as n loop
				set_point_on_circle (point_array [n.item + 1], apex, a_angle + radians (90 * n.item), size)
			end
		end

end