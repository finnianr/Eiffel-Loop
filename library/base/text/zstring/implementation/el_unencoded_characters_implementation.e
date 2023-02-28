note
	description: "Implementation routines for [$source EL_UNENCODED_CHARACTERS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-28 8:22:10 GMT (Tuesday 28th February 2023)"
	revision: "19"

deferred class
	EL_UNENCODED_CHARACTERS_IMPLEMENTATION

inherit
	EL_EXTENDABLE_AREA [CHARACTER_32]
		export
			{ANY} area
		end

	EL_INTERVAL_CONSTANTS
		export
			{NONE} all
		end

	EL_SHARED_IMMUTABLE_32_MANAGER

	EL_SHARED_STRING_8_CURSOR

	EL_SHARED_STRING_32_CURSOR

	EL_ZCODE_CONVERSION

feature -- Contract Support

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

	empty_buffer: EL_UNENCODED_CHARACTERS_BUFFER
--		require
--			not_in_use: not Buffer.in_use
		do
			Result := Buffer
			Result.wipe_out
--			Result.set_in_use (True)
		end

	empty_index_list: ARRAYED_LIST [INTEGER]
		do
			Result := Once_index_list
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
			Result := empty_index_list
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				Result.extend (i)
				i := i + section_count (l_area, i) + 2
			end
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

	shared_cursor (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		do
			if attached {READABLE_STRING_32} general as str_32 then
				Result := cursor_32 (str_32)

			elseif attached {READABLE_STRING_8} general as str_8 then
				Result := cursor_8 (str_8)
			else
				Result := cursor_32 (general.to_string_32)
			end
		end

feature {NONE} -- `count_greater_than_zero_flags' values

	Both_have_mixed_encoding: INTEGER = 3

	Neither: INTEGER = 0

	Only_current: INTEGER = 2

	Only_other: INTEGER = 1

feature {NONE} -- Constants

	Buffer: EL_UNENCODED_CHARACTERS_BUFFER
		once
			create Result.make
		end

	Empty_unencoded: SPECIAL [CHARACTER_32]
		once
			create Result.make_empty (0)
		end

	Minimum_capacity: INTEGER = 3

	Once_index_list: ARRAYED_LIST [INTEGER]
		once
			create Result.make (5)
		end

	Once_interval_index_array: SPECIAL [EL_UNENCODED_CHARACTERS_INDEX]
		once
			create Result.make_empty (2)
			Result.extend (create {EL_UNENCODED_CHARACTERS_INDEX}.make_default)
			Result.extend (create {EL_UNENCODED_CHARACTERS_INDEX}.make_default)
		end

	Unencoded_insert: SPECIAL [CHARACTER_32]
		once
			create Result.make_empty (3)
		end

end