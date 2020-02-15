note
	description: "3D vertice coordinate in wet and dry CAD model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-15 19:54:58 GMT (Saturday 15th February 2020)"
	revision: "1"

class
	COORDINATE_VECTOR

inherit
	VECTOR_DOUBLE
		rename
			make as make_vector
		undefine
			out
		end

	DEBUG_OUTPUT undefine copy, is_equal end

create
	make, make_column

feature {NONE} -- Initialization

	make (a_area: like area; a_index: INTEGER)
		do
			area := a_area; index := a_index
			height := a_area.count; width := 1
		end

feature -- Status query

	is_dry: BOOLEAN
		-- `True' if point is above water
		do
			Result := z > z.zero
		end

	is_wet: BOOLEAN
		-- `True' if point is under water
		do
			Result := z < z.zero
		end

	is_boundary: BOOLEAN
		-- `True' if point is on water boundary
		do
			Result := z = z.zero
		end

	surface_intersection (other: like Current): like Current
		-- point of intersection of line drawn from `Current' to `other' with water surface plane
		require
			opposites: (is_dry implies other.is_wet) and (is_wet implies other.is_dry)
		local
			product_1, product_2: DOUBLE
			direction: like Vector
		do
			direction := Vector
			direction.set_area (area)
			direction.subtract (other)
			direction.normalize

			product_1 := dot (Water_plane_normal)
			product_2 := direction.dot (Water_plane_normal)
			create Result.make (area.twin, -1)
			Result.scale_by (product_1 / product_2)
		end

feature -- Access

	index: INTEGER
		-- zero index into {CAD_MODEL}.vertice_list

	x: DOUBLE
		do
			Result := area [0]
		end

	y: DOUBLE
		do
			Result := area [1]
		end

	z: DOUBLE
		do
			Result := area [2]
		end

	debug_output: STRING
		do
			Result := Format_out #$ [x, y, z]
		end

feature {NONE} -- Constants

	Vector: COORDINATE_VECTOR
		once
			create Result.make_column (3)
		end

	Water_plane_normal: COORDINATE_VECTOR
		once
			create Result.make_column (3)
			Result [3] := 1
		end

	Format_out: ZSTRING
		once
			Result := "%S, %S, %S"
		end
end
