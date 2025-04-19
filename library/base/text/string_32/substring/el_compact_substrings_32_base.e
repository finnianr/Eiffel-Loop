note
	description: "Implementation routines for ${EL_COMPACT_SUBSTRINGS_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 7:20:00 GMT (Saturday 19th April 2025)"
	revision: "37"

deferred class
	EL_COMPACT_SUBSTRINGS_32_BASE

inherit
	EL_EXTENDABLE_AREA [CHARACTER_32]

	EL_STRING_HANDLER

	EL_INTERVAL_CONSTANTS
		export
			{NONE} all
		end

	EL_TYPED_POINTER_ROUTINES_I

	EL_SHARED_IMMUTABLE_32_MANAGER

	EL_ZCODE_CONVERSION

feature -- Contract Support

	contains_all_intervals (interval_list: EL_ARRAYED_INTERVAL_LIST): BOOLEAN
		do
			if attached interval_list as list then
				Result := True
				from list.start until not Result or list.after loop
					Result := contains_interval (list.item_lower, list.item_upper)
					list.forth
				end
			end
		end

	contains_interval (lower_A, upper_A: INTEGER): BOOLEAN
		local
			ir: EL_INTERVAL_ROUTINES; l_area: like area
			i, lower_B, upper_B: INTEGER
		do
			l_area := area
			from i := 0 until Result or else i = l_area.count loop
				lower_B := l_area [i].code; upper_B := l_area [i + 1].code
				Result := ir.overlap_status (lower_A, upper_A, lower_B, upper_B) = B_contains_A
				i := i + upper_B - lower_B + 3
			end
		end

	interval_sequence: EL_SEQUENTIAL_INTERVALS
		local
			i, lower, upper: INTEGER; l_area: like area
		do
			create Result.make (3)
			l_area := area
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				Result.extend (lower, upper)
				i := i + upper - lower + 3
			end
		end

	is_valid: BOOLEAN
		-- `True' if all intervals valid and in sequence and consistent with size of `area'
		local
			i, lower, upper, count, previous_upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			Result := True
			from i := 0 until not Result or else i = i_final loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				Result := lower <= upper and then lower > previous_upper and then i + count + 2 <= i_final
				previous_upper := upper
				i := i + count + 2
			end
		end

	substring_list: SPECIAL [STRING_32]
			-- Debugging output
		local
			i, j, lower, upper, count, i_final: INTEGER; l_area: like area
			list: ARRAYED_LIST [STRING_32]; string: STRING_32
		do
			create list.make (10)
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				create string.make (count + 8)
				string.append_integer (lower)
				string.append_character ('-')
				string.append_integer (upper)
				string.append_string_general (": ")
				from j := 1 until j > count loop
					string.extend (l_area.item (i + 1 + j).to_character_32)
					j := j + 1
				end
				list.extend (string)
				i := i + count + 2
			end
			Result := list.area_v2
		end

feature {NONE} -- Deferred

	character_count: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	change_case (as_lower_case: BOOLEAN)
		local
			i, j, index, count, i_final: INTEGER; l_area: like area
			c, new_c: CHARACTER_32
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				count := section_count (l_area, i)
				from j := 1 until j > count loop
					index := i + 1 + j
					c := l_area.item (index).to_character_32
					if as_lower_case then
						new_c := c.as_lower
					else
						new_c := c.as_upper
					end
					if c /= new_c then
						l_area [index] := new_c
					end
					j := j + 1
				end
				i := i + count + 2
			end
		end

	empty_buffer: EL_COMPACT_SUBSTRINGS_32_BUFFER
		do
			Result := Buffer
			Result.wipe_out
		end

	extend_bounds (a_area: like area; lower, upper: INTEGER)
		do
			a_area.extend (lower.to_character_32)
			a_area.extend (upper.to_character_32)
		end

	extended_enough (a_area: like area; destination_index, lower, upper: INTEGER; uc: CHARACTER_32): like area
		local
			l_insert: like area
		do
			l_insert := Unencoded_insert; l_insert.wipe_out
			if lower > 0 then
				l_insert.extend (lower.to_character_32)
			end
			if upper > 0 then
				l_insert.extend (upper.to_character_32)
			end
			if uc > '%U' then
				l_insert.extend (uc)
			end
			Result := big_enough (a_area, l_insert.count)
			Result.insert_data (l_insert, 0, destination_index, l_insert.count)
		end

	index_list: ARRAYED_LIST [INTEGER]
		local
			i, i_final: INTEGER; l_area: like area
		do
			Result := Once_index_list.emptied
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				Result.extend (i)
				i := i + section_count (l_area, i) + 2
			end
		end

	index_of_overlapping (a_area: like area; lower_A, upper_A: INTEGER): INTEGER
		-- index of first substring overlapping interval `lower_A .. upper_A'
		-- or else `a_area.count' if not found
		local
			found: BOOLEAN; ir: EL_INTERVAL_ROUTINES
			i, lower_B, upper_B, overlap_status: INTEGER
		do
			if a_area.count > 0 and then upper_A >= a_area [0].code then
				from i := 0 until found or i = a_area.count loop
					lower_B := a_area [i].code; upper_B := a_area [i + 1].code

					overlap_status := ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					if ir.is_overlapping (overlap_status) then
						found := True
					else
						i := i + upper_B - lower_B + 3
					end
				end
			else
				Result := a_area.count
			end
			Result := i
		end

	interval_count (a_area: like area; start_index: INTEGER): INTEGER
		do
			if a_area.valid_index (start_index) then
				Result := a_area [start_index - 1].code - a_area [start_index - 2].code + 1
			end
		end

	null: TYPED_POINTER [INTEGER]
		do
		end

	put_lower (a_area: like area; i, lower: INTEGER)
		do
			a_area.put (lower.to_character_32, i)
		end

	put_upper (a_area: like area; i, upper: INTEGER)
		do
			a_area.put (upper.to_character_32, i + 1)
		end

	remove_section (a_area: like area; i, lower, upper, start_index, end_index, deleted_count: INTEGER): INTEGER
		local
			count_to_remove, source_index, destination_index: INTEGER
		do
			count_to_remove := end_index - start_index + 1
			if lower = start_index and then upper = end_index then
				destination_index := i
				count_to_remove := count_to_remove + 2
			else
				destination_index := i + 2 + start_index - lower
			end
			source_index := destination_index + count_to_remove
			a_area.overlapping_move (source_index, destination_index, a_area.count - source_index)
			a_area.remove_tail (count_to_remove)
			if destination_index > i then
				if start_index = lower then
					-- Remove from start
					a_area [i] := (lower + count_to_remove - deleted_count).to_character_32
					a_area [i + 1] := (upper - deleted_count).to_character_32
				else
					a_area [i + 1] := (upper - count_to_remove).to_character_32
				end
			end
			Result := count_to_remove
		end

	section_count (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area [i + 1].code - a_area [i].code + 1
		end

feature {NONE} -- `count_greater_than_zero_flags' values

	Both_have_mixed_encoding: INTEGER = 3

	Neither: INTEGER = 0

	Only_current: INTEGER = 2

	Only_other: INTEGER = 1

feature {NONE} -- Constants

	Buffer: EL_COMPACT_SUBSTRINGS_32_BUFFER
		once
			create Result.make
		end

	Empty_unencoded: SPECIAL [CHARACTER_32]
		once
			create Result.make_empty (0)
		end

	Minimum_capacity: INTEGER = 3

	Once_index_list: EL_ARRAYED_LIST [INTEGER]
		once
			create Result.make (5)
		end

	Unencoded_insert: SPECIAL [CHARACTER_32]
		once
			create Result.make_empty (3)
		end

end