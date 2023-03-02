note
	description: "Extendable [$source EL_UNENCODED_CHARACTERS] temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-02 14:49:33 GMT (Thursday 2nd March 2023)"
	revision: "26"

class
	EL_UNENCODED_CHARACTERS_BUFFER

inherit
	EL_UNENCODED_CHARACTERS
		export
			 {NONE} area
		redefine
			last_index
		end

create
	make

feature -- Access

	area_copy: like area
		do
			create Result.make_empty (area.count)
			Result.insert_data (area, 0, 0, area.count)
		end

feature -- Status query

	in_use: BOOLEAN

feature -- Element change

	append_from_area (a_area: like area; index: INTEGER)
		local
			lower, upper: INTEGER; l_area, current_area: like area
		do
			last_index := index
			lower := a_area [index].code; upper := a_area [index + 1].code
			l_area := area; current_area := l_area
			l_area := big_enough (l_area, index + upper - lower + 3)
			l_area.copy_data (a_area, 0, 0, index + upper - lower + 3)
			set_if_changed (current_area, l_area)
		end

	append_final (accumulator: like area)
		do
			if accumulator.count - 1 > 0 then
				append_accumulated (accumulator)
			end
		end

	append_substring (other: EL_UNENCODED_CHARACTERS; lower_A, upper_A, offset: INTEGER)
		local
			i, lower_B, upper_B, overlap_status: INTEGER
			ir: EL_INTERVAL_ROUTINES; o_area: like area; done, searching: BOOLEAN
		do
			o_area := other.area; searching := True
			from i := 0 until done or i = o_area.count loop
				lower_B := o_area [i].code; upper_B := o_area [i + 1].code
				overlap_status := ir.overlap_status (lower_A, upper_A, lower_B, upper_B)

				if searching and then ir.is_overlapping (overlap_status) then
					searching := False
				end
				if not searching then
					inspect overlap_status
						when B_contains_A then
							-- Append full interval
							append_interval (o_area, i + 2 + (lower_A - lower_B), 1, upper_A - lower_A + 1, offset)
						when A_contains_B then
							-- Append full interval
							append_interval (o_area, i + 2, lower_B - lower_A + 1, upper_B - lower_A + 1, offset)
						when A_overlaps_B_left then
							-- Append left section
							append_interval (o_area, i + 2, lower_B - lower_A + 1, upper_A - lower_A + 1, offset)
						when A_overlaps_b_right then
							-- Append right section
							append_interval (o_area, i + 2 + (lower_A - lower_B), 1, upper_B - lower_A + 1, offset)
					else
						done := True
					end
				end
				i := i + upper_B - lower_B + 3
			end
		end

	append_substituted (
		a_area: SPECIAL [CHARACTER]; unencoded_area, accumulator: SPECIAL [CHARACTER_32]
		block_index_ptr: POINTER; source_offset, destination_offset, a_count: INTEGER;
	)
		-- append all unencoded characters in `a_area' in the range indicated by `source_offset'
		-- and `a_count'. Requires external call to `append_final' to complete.
		local
			i, j: INTEGER; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			from i := 0 until i = a_count loop
				j := i + source_offset
				if a_area [j] = Substitute then
					try_appending (accumulator, i + destination_offset, iter.item (block_index_ptr, unencoded_area, j + 1))
				end
				i := i + 1
			end
		end
		
	extend (uc: CHARACTER_32; index: INTEGER)
		local
			area_count, l_last_upper: INTEGER; l_area, current_area: like area
		do
			l_area := area; current_area := l_area; area_count := l_area.count
			if l_area.count > 0 then
				l_last_upper := l_area [last_index + 1].code
			else
				l_last_upper := (1).opposite
			end
			if l_last_upper + 1 = index then
				l_area := big_enough (l_area, 1)
				l_area.put (index.to_character_32, last_index + 1)
				l_area.extend (uc)
			else
				last_index := area_count
				l_area := big_enough (l_area, 3)
				l_area.extend (index.to_character_32)
				l_area.extend (index.to_character_32)
				l_area.extend (uc)
			end
			set_if_changed (current_area, l_area)
		end

	extend_z_code (a_z_code: NATURAL; index: INTEGER)
		do
			extend (z_code_to_unicode (a_z_code).to_character_32, index)
		end

	try_appending (accumulator: like area; index: INTEGER; uc: CHARACTER_32)
		-- first code of `accumulator' is the last index
		-- `index' is zero based for `SPECIAL' array
		do
			if accumulator.count = 0 then
				accumulator.extend ('%U')

			elseif accumulator.capacity = accumulator.count or accumulator [0].code /= index then
				append_accumulated (accumulator)
				accumulator.wipe_out
				accumulator.extend ('%U')
			end
			accumulator.extend (uc)
			accumulator [0] := (index + 1).to_character_32
		end

feature -- Removal

	wipe_out
		do
			area.wipe_out
			last_index := 0
		end

feature {NONE} -- Implementation

	append_accumulated (accumulator: like area)
		local
			lower, upper, index: INTEGER; l_area, current_area: like area
		do
			index := accumulator [0].code
			l_area := area; current_area := l_area
			if last_index.to_boolean and then last_index = index - accumulator.count + 1 then
				-- reaches here when `accumulator' is full and is about to be emptied
				l_area := big_enough (l_area, accumulator.count - 1)
				l_area.copy_data (accumulator, 1, l_area.count, accumulator.count - 1)
				l_area [last_upper_index] := index.to_character_32
			else
				lower := index - accumulator.count + 2
				upper := index
				l_area := big_enough (l_area, accumulator.count + 1)
				l_area.extend (lower.to_character_32); l_area.extend (upper.to_character_32)
				last_upper_index := l_area.count - 1
				l_area.copy_data (accumulator, 1, l_area.count, accumulator.count - 1)
			end
			last_index := index
			set_if_changed (current_area, l_area)
		ensure
			is_valid: is_valid
		end

	append_interval (a_area: like area; source_index, a_lower, a_upper, offset: INTEGER)
		-- append interval from `a_lower' to `a_upper' shifted by `offset' to the right (left if negative)
		local
			count, i: INTEGER; l_area, current_area: like area
		do
			l_area := area; current_area := l_area; i := last_index; count := a_upper - a_lower + 1
			if l_area.count > 0 and then l_area [i + 1].code + 1 = a_lower + offset then
				-- merge intervals
				l_area := big_enough (l_area, count)
				l_area.copy_data (a_area, source_index, l_area.count, count)
				put_upper (l_area, i, a_upper + offset)
			else
				l_area := big_enough (l_area, count + 2)
				extend_bounds (l_area, a_lower + offset, a_upper + offset)
				l_area.copy_data (a_area, source_index, l_area.count, count)
				last_index := l_area.count - (a_upper - a_lower + 3)
			end
			set_if_changed (current_area, l_area)
		ensure
			count_increased_by_count: character_count = old character_count + a_upper - a_lower + 1
		end

	valid_last_index: BOOLEAN
		do
			Result := area.count > 0 implies last_index + section_count (area, last_index) + 2 = area.count
		end

feature {NONE} -- Internal attributes

	last_index: INTEGER

	last_upper_index: INTEGER

invariant
	valid_last_index: valid_last_index

end