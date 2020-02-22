note
	description: "Coordinate in 3D space"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-22 12:17:35 GMT (Saturday 22nd February 2020)"
	revision: "8"

class
	COORDINATE_VECTOR

inherit
	VECTOR_DOUBLE
		rename
			make as make_matrix,
			make_from as make_from_other
		redefine
			out
		end

	DEBUG_OUTPUT undefine copy, is_equal, out end

	HASHABLE undefine copy, is_equal, out end

create
	make_from_area, make, make_from_other, make_from_tuple

convert
	make_from_tuple ({TUPLE [DOUBLE, DOUBLE, DOUBLE]})

feature {NONE} -- Initialization

	make_from_tuple (arg: TUPLE [x, y, z: DOUBLE])
		do
			make (arg.x, arg.y, arg.z)
		end

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
			Result := out
		end

	out: STRING
		do
			Result := Format_out #$ [x, y, z]
		end

	closest (a, b: like Current): like Current
		-- point `a' or `b' that is closest to `Current'
		do
			if distance (a) < distance (b) then
				Result := a
			else
				Result := b
			end
		end

	distance (other: like Current): DOUBLE
		-- distance to `other' point
		local
			difference: like Once_vector
		do
			difference := Once_vector
			difference.area.copy_data (other.area, 0, 0, 3)
			difference.subtract (Current)
			Result := difference.magnitude
		end

	furthest (a, b: like Current): like Current
		-- point `a' or `b' that is furthest from `Current'
		do
			if distance (a) > distance (b) then
				Result := a
			else
				Result := b
			end
		end

	hash_code: INTEGER
		local
			i, j, l_count, value_part, byte_count: INTEGER
			value: DOUBLE; value_ptr, value_part_ptr: POINTER
		do
			if internal_hash_code = 0 then
				value_part_ptr := $value_part; value_ptr := $value
				byte_count := {PLATFORM}.Integer_32_bytes
				from i := 0 until i = area.count loop
					value := area [i]
					from j := 0 until j > byte_count  loop
						value_part_ptr.memory_copy (value_ptr + j, byte_count)
						Result := Result + value_part
						j := j + byte_count
					end
					i := i + 1
				end
				Result := Result.abs
				internal_hash_code := Result
			else
				Result := internal_hash_code
			end
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

	Once_vector: COORDINATE_VECTOR
		once
			create Result.make (0, 0, 0)
		end

end
