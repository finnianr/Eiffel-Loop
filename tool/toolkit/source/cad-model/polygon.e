note
	description: "Polygon coordinates in wet and dry CAD model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-17 11:45:31 GMT (Monday 17th February 2020)"
	revision: "4"

class
	POLYGON

inherit
	EL_ARRAYED_LIST [COORDINATE_VECTOR]
		rename
			make as make_sized,
			item as point
		redefine
			out
		end

	DEBUG_OUTPUT undefine copy, is_equal, out end

	EL_SHARED_ONCE_STRING_8

create
	make, make_sized

feature {NONE} -- Initialization

	make (vertice_indices: CHAIN [INTEGER]; coordinate_array: SPECIAL [SPECIAL [DOUBLE]])
		require
			valid_indices: across vertice_indices as v_index all coordinate_array.valid_index (v_index.item) end
		do
			make_sized (vertice_indices.count)
			compare_objects
			across vertice_indices as v_index loop
				extend (create {COORDINATE_VECTOR}.make_from_area (coordinate_array [v_index.item]))
			end
		end

feature -- Access

	dry_part: like Current
		require
			has_wet_part: across Current as coord some coord.item.is_wet end
		do
			Result := new_partial (agent {COORDINATE_VECTOR}.is_wet)
		end

	wet_part: like Current
		require
			has_dry_part: across Current as coord some not coord.item.is_dry end
		do
			Result := new_partial (agent {COORDINATE_VECTOR}.is_dry)
		end

	debug_output: STRING
		do
			Result := out
		end

	out: STRING
		do
			create Result.make_filled ('D', count)
			across Current as coord loop
				if coord.item.is_wet then
					Result [coord.cursor_index] := 'W'
				elseif coord.item.is_boundary then
					Result [coord.cursor_index] := 'B'
				end
			end
		end

feature -- Status query

	is_dry: BOOLEAN
		do
			Result := across Current as coord all coord.item.z >= 0 end
		end

	is_wet: BOOLEAN
		do
			Result := across Current as coord all coord.item.z <= 0 end
		end

	is_wet_and_dry: BOOLEAN
		do
			Result := across Current as coord some coord.item.is_dry end
							and then across Current as coord some coord.item.is_wet end
		end

feature -- Comparison

   is_approximately_equal (other: like Current; precision: DOUBLE ): BOOLEAN
   	do
   		if count = other.count then
   			Result := across Current as coord all coord.item.is_approximately_equal (other [coord.cursor_index], precision)  end
   		end
   	end

feature -- Basic operations

	print_to (lio: EL_LOGGABLE)
		local
			str: STRING
		do
			lio.put_labeled_string ("Code", out)
			lio.put_new_line
			across Current as coord loop
				str := empty_once_string_8
				coord.item.append_to_string (str)
				lio.put_labeled_substitution ("Coord", "[%S] = [%S]", [coord.cursor_index, str])
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	new_partial_X (excluded: PREDICATE [COORDINATE_VECTOR]): like Current
		-- polygon that is cut above or below waterplane according to `excluded' predicate
		local
			first_included, last_included, first_excluded, last_excluded: COORDINATE_VECTOR
			offset, i: INTEGER;
		do
			create Result.make_sized (count)
			-- Pythonic circular zero based indexing
			-- use `offset' to effect a rotation such that `not excluded (point)' is first and `exluded (point)' is last
			from offset := 0 until not excluded (circular_i_th (offset)) and excluded (circular_i_th (offset + count - 1)) loop
				offset := offset + 1
			end
			from i := offset until excluded (circular_i_th (i)) loop
				Result.extend (circular_i_th (i))
				i := i + 1
			end
			last_included := circular_i_th (i - 1); first_excluded := circular_i_th (i)
			if not last_included.is_boundary then
				Result.extend (last_included.surface_intersection (first_excluded))
			end
			first_included := circular_i_th (offset); last_excluded := circular_i_th (offset - 1)
			if not first_included .is_boundary then
				Result.extend (first_included.surface_intersection (last_excluded))
			end
		end

	new_partial (excluded: PREDICATE [COORDINATE_VECTOR]): like Current
		-- polygon that is cut above or below waterplane according to `excluded' predicate
		local
			first_included, last_included, first_excluded, last_excluded: COORDINATE_VECTOR
			offset, i, included_count: INTEGER;
		do
			included_count := count - count_of (excluded)
			create Result.make_sized (included_count + 2)

			-- Pythonic circular zero based indexing
			-- use `offset' to effect a rotation such that `not excluded (point)' is first and `exluded (point)' is last
			from offset := 0 until not excluded (circular_i_th (offset)) and excluded (circular_i_th (offset + count - 1)) loop
				offset := offset + 1
			end

			-- Add included points
			from i := 0 until i = included_count loop
				Result.extend (circular_i_th (i + offset))
				i := i + 1
			end
			-- Add intersection of first and last included points with adjacent point on opposite side of plane
			last_included := circular_i_th (offset + included_count - 1)
			first_excluded := circular_i_th (offset + included_count)
			if not last_included.is_boundary then
				Result.extend (last_included.surface_intersection (first_excluded))
			end
			first_included := circular_i_th (offset); last_excluded := circular_i_th (offset - 1)
			if not first_included .is_boundary then
				Result.extend (first_included.surface_intersection (last_excluded))
			end
		end

end
