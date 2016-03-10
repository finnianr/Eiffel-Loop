note
	description: "[
		Sub arrays implemented using shared memory areas rather than copied memory area. 
		For large arrays, subarray memory copies can incurr a significant performance overhead. 
		Using shared memory subarrays can in some applications reduce execution time by as much as 50%. (hard to believe I know)
		
		Sub array can be referenced using either lower to upper indexes of parent array or 1 based index.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SUBARRAY [G]

inherit
	ARRAY [G]
		rename
			area as shared_area,
			subcopy as subcopy_array
		export
			{NONE} all
			{ANY} count, item, valid_index, lower, upper, subcopy_array, is_empty
			{ARRAY} shared_area
		redefine
			item, subarray, make_from_array, make, subcopy_array
		end

create
	make, make_subarray, make_from_array, make_from_other, make_from_subarray

feature -- Initialization

	make (min_index, max_index: INTEGER)
			--
		do
			Precursor (min_index, max_index)
			normal_lower := lower
		end

	make_from_other (other: EL_SUBARRAY [like item])
			--
		do
			make_from_array (other)
			normal_lower := other.lower
			offset := other.offset
		end

	make_from_array (a: ARRAY [like item])
			--
		do
			Precursor (a)
			normal_lower := lower
		end

	make_subarray (a: ARRAY [like item]; start_pos, end_pos: INTEGER)
			--
		do
			make_from_array (a)
			offset := start_pos - a.lower
			lower := start_pos
			upper := end_pos
			normal_lower := lower
		end

	make_from_subarray (a: EL_SUBARRAY [like item]; start_pos, end_pos: INTEGER)
			--
		do
			make_from_other (a)
			offset := offset + start_pos - lower
			lower := start_pos
			upper := end_pos
			normal_lower := lower
		end

feature -- Access

	item alias "[]" (i: INTEGER): G assign put
			-- Entry at index `i', if in index interval
		do
			Result := shared_area.item (offset + i - lower)
		end

feature -- Status setting

	set_one_based
			--
		do
			upper := upper - lower + 1
			lower := 1
		end

	set_lower_based
			--
		do
			lower := normal_lower
			upper := upper + normal_lower - 1
		end

feature -- Element change

	subcopy (other: EL_SUBARRAY [like item]; start_pos, end_pos, index_pos: INTEGER)
			--
		do
			shared_area.copy_data (
				other.shared_area, other.offset + start_pos - other.lower, offset + index_pos - lower, end_pos - start_pos + 1
			)
		end

	subcopy_array (other: ARRAY [like item]; start_pos, end_pos, index_pos: INTEGER)
			--
		do
			shared_area.copy_data (
				other.area, start_pos - other.lower, offset + index_pos - lower, end_pos - start_pos + 1
			)
		end

	set_normal_lower (v: INTEGER)
			--
		do
			normal_lower := v
		end

feature -- Duplication

	subarray (start_pos, end_pos: INTEGER): EL_SUBARRAY [G]
			--
		do
			create Result.make_from_subarray (Current, start_pos, end_pos)
		end

feature -- Status query

	is_one_based: BOOLEAN
			--
		do
			Result := lower = 1
		end

feature -- Conversion

	to_array: ARRAY [like item]
			--
		do
			create Result.make (lower, upper)
			Result.area.copy_data (shared_area, offset, 0, count)
		end

feature {ARRAY} -- Implementation

	offset: INTEGER
			-- Area offset

	normal_lower: INTEGER

end
