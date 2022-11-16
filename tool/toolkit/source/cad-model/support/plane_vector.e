note
	description: "Normalized vector of plane with `distance' from origin"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	PLANE_VECTOR

inherit
	VECTOR_DOUBLE
		rename
			make as make_matrix,
			make_from as make_from_other
		end

	EL_DOUBLE_MATH undefine copy, is_equal, out end

create
	make

feature {NONE} -- Initialization

	make (a_x, a_y, a_z, a_distance: DOUBLE)
		require
			normalized: across << a_x, a_y, a_z >> as coord all coord.item.abs <= 1.0 end
		do
			array_make_from_array (<< a_x, a_y, a_z >>)
			width := 3; height := 1; distance := a_distance
		end

feature -- Measurement

	distance: DOUBLE
		-- distance from origin

	intersection_point (a, b: COORDINATE_VECTOR): COORDINATE_VECTOR
		local
			product_1, product_2: DOUBLE
			ab, plane: COORDINATE_VECTOR
		do
			create Result.make_from_other (a)

			plane := current_plane
			ab := Difference
			ab.area.copy_data (b.area, 0, 0, 3)
			ab.subtract (a)

			product_1 := plane.dot (a)
			product_2 := plane.dot (ab)

			ab.scale_by (distance - product_1 / product_2)
			Result.add (ab)
		ensure
			-- points either on same side of plane (1) or else one opposite sides (2)
			same_distances: approximately_equal (a.distance (b), a.distance (Result) + Result.distance (b), 0.1e-14) -- 1
				 or else approximately_equal (
						Result.distance (Result.closest (a, b)) + a.distance (b), Result.distance (Result.furthest (a, b)), 0.1e-14 -- 2
					)
		end

feature {NONE} -- Implementation

	current_plane: COORDINATE_VECTOR
		do
			Result := Vector
			Result.area.copy_data (area, 0, 0, 3)
		end

feature {NONE} -- Constants

	Difference: COORDINATE_VECTOR
		once
			create Result.make (0, 0, 0)
		end

	Vector: COORDINATE_VECTOR
		once
			create Result.make (0, 0, 0)
		end

end