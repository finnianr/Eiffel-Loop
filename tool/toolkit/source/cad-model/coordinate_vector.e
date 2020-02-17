note
	description: "3D vertice coordinate in wet and dry CAD model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-17 16:11:42 GMT (Monday 17th February 2020)"
	revision: "5"

class
	COORDINATE_VECTOR

inherit
	VECTOR_DOUBLE
		rename
			make as make_matrix,
			make_from as make_from_other
		undefine
			out
		end

	DEBUG_OUTPUT undefine copy, is_equal end

	HASHABLE undefine copy, is_equal end

	EL_DOUBLE_MATH undefine copy, is_equal end

create
	make_from_area, make, make_from_other

feature {NONE} -- Initialization

	make (a_x, a_y, a_z: DOUBLE)
		do
			make_from_area ((<< a_x, a_y , a_z >>).area)
		end

	make_from_area (a_area: like area)
		do
			area := a_area
			lower := 1; upper := 3
			width := a_area.count; height := 1
		end

feature -- Access

	debug_output: STRING
		do
			Result := Format_out #$ [x, y, z]
		end

	distance (other: like Current): DOUBLE
		local
			difference: like Once_vector
		do
			difference := Once_vector
			difference.area.copy_data (other.area, 0, 0, 3)
			difference.subtract (Current)
			Result := difference.magnitude
		end

	hash_code: INTEGER
		local
			i, l_count: INTEGER
			l_memory: like Memory
		do
			if internal_hash_code = 0 then
				l_memory := Memory
				l_memory.set_from_pointer (area.base_address, {PLATFORM}.Real_64_bytes * area.count)
				l_count := l_memory.count
				from i := 0 until i = l_count loop
					-- The magic number `8388593' below is the greatest prime lower than
					-- 2^23 so that this magic number shifted to the left does not exceed 2^31.

					Result := ((Result \\ 8388593) |<< 8) + l_memory.read_natural_8 (i)
					i := i + 1
				end
				internal_hash_code := Result
			else
				Result := internal_hash_code
			end
		end

	surface_intersection (other: like Current): like Current
		-- point of intersection of line drawn from `Current' to `other' with water surface plane
		require
			opposites: (is_dry implies other.is_wet) and (is_wet implies other.is_dry)
		local
			product_1, product_2: DOUBLE
			difference: like Once_vector
		do
			create Result.make_from_other (Current)

			difference := Once_vector
			difference.area.copy_data (other.area, 0, 0, 3)
			difference.subtract (Current)

			product_1 := Water_plane_normal.dot (Current)
			product_2 := Water_plane_normal.dot (difference)

			difference.scale_by (product_1.opposite / product_2)
			Result.add (difference)
		ensure
			same_distance_sum: approximately_equal (distance (other), distance (Result) + Result.distance (other), 0.1e-14)
		end

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

feature -- Status query

	is_boundary: BOOLEAN
		-- `True' if point is on water boundary
		do
			Result := z = z.zero
		end

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

feature -- Basic operations

	append_to_string (str: STRING)
		local
			i: INTEGER
		do
			from i := 0 until i = 3 loop
				if i > 0 then
					str.append (once ", ")
				end
				str.append_double (area [i])
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	internal_hash_code: INTEGER

feature {NONE} -- Constants

	Format_out: ZSTRING
		once
			Result := "[%S, %S, %S]"
		end

	Memory: MANAGED_POINTER
		once
			create Result.share_from_pointer (Default_pointer, 0)
		end

	Once_vector: COORDINATE_VECTOR
		once
			create Result.make (0, 0, 0)
		end

	Water_plane_normal: COORDINATE_VECTOR
		once
			create Result.make (0, 0, 1)
		end

end
