note
	description: "Implementation routines for [$source EL_UNENCODED_CHARACTERS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-03 16:52:23 GMT (Wednesday 3rd February 2021)"
	revision: "1"

deferred class
	EL_UNENCODED_CHARACTERS_IMPLEMENTATION

feature {NONE} -- Contract Support

	is_unencoded_valid: BOOLEAN
		do
			Result := True
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
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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

	area: SPECIAL [NATURAL]
		deferred
		end

	big_enough (a_area: like area; additional_count: INTEGER): like area
		deferred
		end

	character_count: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	change_case (as_lower_case: BOOLEAN)
		local
			i, j, index, lower, upper, count, i_final: INTEGER; l_area: like area
			c, new_c: CHARACTER_32
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				from j := 1 until j > count loop
					index := i + 1 + j
					c := l_area.item (index).to_character_32
					if as_lower_case then
						new_c := c.as_lower
					else
						new_c := c.as_upper
					end
					if c /= new_c then
						l_area [index] := new_c.natural_32_code
					end
					j := j + 1
				end
				i := i + count + 2
			end
		end

	empty_buffer: EL_UNENCODED_CHARACTERS_BUFFER
		do
			Result := Buffer
			Result.wipe_out
		end

	extend_bounds (a_area: like area; lower, upper: INTEGER)
		do
			a_area.extend (lower.to_natural_32)
			a_area.extend (upper.to_natural_32)
		end

	extended (destination_index, lower, upper: INTEGER; a_code: NATURAL): like area
		local
			l_insert: like area
		do
			Result := area; l_insert := Unencoded_insert; l_insert.wipe_out
			if lower > 0 then
				l_insert.extend (lower.to_natural_32)
			end
			if upper > 0 then
				l_insert.extend (upper.to_natural_32)
			end
			if a_code > 0 then
				l_insert.extend (a_code)
			end
			Result := big_enough (Result, l_insert.count)
			Result.insert_data (l_insert, 0, destination_index, l_insert.count)
		end

	index_list: ARRAYED_LIST [INTEGER]
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			Result := Once_index_list
			Result.wipe_out
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				Result.extend (i)
				i := i + upper - lower + 3
			end
		end

	lower_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i).to_integer_32
		end

	put_lower (a_area: like area; i, lower: INTEGER)
		do
			a_area.put (lower.to_natural_32, i)
		end

	put_upper (a_area: like area; i, upper: INTEGER)
		do
			a_area.put (upper.to_natural_32, i + 1)
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
					a_area [i] := (lower + count_to_remove - deleted_count).to_natural_32
					a_area [i + 1] := (upper - deleted_count).to_natural_32
				else
					a_area [i + 1] := (upper - count_to_remove).to_natural_32
				end
			end
			Result := count_to_remove
		end

	upper_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i + 1).to_integer_32
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

	Empty_unencoded: SPECIAL [NATURAL]
		once
			create Result.make_empty (0)
		end

	Minimum_capacity: INTEGER = 3

	Once_index_list: ARRAYED_LIST [INTEGER]
		once
			create Result.make (5)
		end

	Once_interval_index_1: EL_UNENCODED_CHARACTERS_INDEX
		once
			create Result.make_default
		end

	Once_interval_index_2: EL_UNENCODED_CHARACTERS_INDEX
		once
			create Result.make_default
		end

	Unencoded_insert: SPECIAL [NATURAL]
		once
			create Result.make_empty (3)
		end

end