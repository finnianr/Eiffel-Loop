note
	description: "3D vertice coordinate in wet and dry CAD model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-16 9:40:02 GMT (Sunday 16th February 2020)"
	revision: "2"

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

	HASHABLE undefine copy, is_equal end

create
	make, make_with_coords

feature {NONE} -- Initialization

	make_with_coords (a_x, a_y, a_z: DOUBLE)
		do
			make ((<< a_x, a_y , a_z >>).area)
		end

	make (a_area: like area)
		do
			area := a_area
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
			ray: like Once_ray_direction
		do
			ray := Once_ray_direction
			ray.set_area (area)
			ray.subtract (other)
			ray.normalize

			product_1 := dot (Water_plane_normal)
			product_2 := ray.dot (Water_plane_normal)
			create Result.make (area.twin)
			Result.subtract (ray.scaled_by (product_1 / product_2))
		end

feature -- Access

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

	hash_code: INTEGER
		local
			i, integer_count: INTEGER
			l_memory: like Memory
		do
			l_memory := Memory
			l_memory.set_from_pointer (area.base_address, {PLATFORM}.Real_64_bytes * area.count)
			integer_count := l_memory.count // {PLATFORM}.Integer_32_bytes
			from i := 0 until i = integer_count loop
				-- The magic number `8388593' below is the greatest prime lower than
				-- 2^23 so that this magic number shifted to the left does not exceed 2^31.

				Result := ((Result \\ 8388593) |<< 8) + l_memory.read_integer_32 (i)
				i := i + 1
			end
		end
		
feature {NONE} -- Constants

	Once_ray_direction: COORDINATE_VECTOR
		once
			create Result.make_with_coords (0, 0, 0)
		end

	Water_plane_normal: COORDINATE_VECTOR
		once
			create Result.make_with_coords (0, 0, 1)
		end

	Format_out: ZSTRING
		once
			Result := "%S, %S, %S"
		end

	Memory: MANAGED_POINTER
		once
			create Result.share_from_pointer (Default_pointer, 0)
		end
end
