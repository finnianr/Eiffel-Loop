note
	description: "Extendable ${EL_COMPACT_SUBSTRINGS_32} with fast appending"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-31 11:11:18 GMT (Sunday 31st March 2024)"
	revision: "34"

class
	EL_COMPACT_SUBSTRINGS_32_BUFFER

inherit
	EL_COMPACT_SUBSTRINGS_32
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

	append_substituted (
		a_area: SPECIAL [CHARACTER]; unencoded_area: SPECIAL [CHARACTER_32]
		block_index_ptr: TYPED_POINTER [INTEGER]; source_offset, destination_offset, a_count: INTEGER
	)
		-- append all unencoded characters in `a_area' in the range indicated by `source_offset'
		-- and `a_count'. Requires external call to `append_final' to complete.
		local
			i, j, l_last_upper: INTEGER; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			uc: CHARACTER_32
		do
			l_last_upper := last_upper
			from i := 0 until i = a_count loop
				j := i + source_offset
				inspect a_area [j]
					when Substitute then
						uc := iter.item (block_index_ptr, unencoded_area, j + 1)
						l_last_upper := extend (uc, l_last_upper, i + destination_offset + 1)
				else
				end
				i := i + 1
			end
			set_last_upper (l_last_upper)
		end

	append_substring (other: EL_COMPACT_SUBSTRINGS_32_I; lower_A, upper_A, offset: INTEGER)
		local
			i, lower_B, upper_B, interval_offset, interval_lower, interval_upper: INTEGER
			ir: EL_INTERVAL_ROUTINES; o_area: like area; overlapping: BOOLEAN
		do
			o_area := other.area; overlapping := True
			from i := index_of_overlapping (o_area, lower_A, upper_A) until not overlapping or i = o_area.count loop
				lower_B := o_area [i].code; upper_B := o_area [i + 1].code

				interval_offset := 0; interval_lower := 1

				inspect ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					when B_contains_A then
						-- Append full interval
						interval_offset := lower_A - lower_B
						interval_upper := upper_A - lower_A + 1

					when A_contains_B then
						-- Append full interval
						interval_lower := lower_B - lower_A + 1
						interval_upper := upper_B - lower_A + 1

					when A_overlaps_B_left then
						-- Append left section
						interval_lower := lower_B - lower_A + 1
						interval_upper := upper_A - lower_A + 1

					when A_overlaps_B_right then
						-- Append right section
						interval_offset := lower_A - lower_B
						interval_upper := upper_B - lower_A + 1
				else
					overlapping := False
				end
				if overlapping then
					append_interval (o_area, i + 2 + interval_offset, interval_lower, interval_upper, offset)
				end
				i := i + upper_B - lower_B + 3
			end
		end

	extend (uc: CHARACTER_32; a_last_upper, index: INTEGER): INTEGER
		-- extend `area' with unencoded character `uc' at `index'
		-- The result is `index' which should be assigned to the calling argument `a_last_upper'
		-- After executing a loop `last_index' in `area' should be updated with a call to `set_last_upper'
		local
			size_increase, capacity: INTEGER; l_area: like area
		do
			if a_last_upper = 0 or else a_last_upper + 1 /= index then
				size_increase := 3
			else
				size_increase := 1
			end
			l_area := area
			capacity := l_area.capacity
			l_area := big_enough (l_area, size_increase)
			if l_area.capacity > capacity then
				area := l_area
			end
			if size_increase = 3 then
				if a_last_upper > 0 then
					l_area.put (a_last_upper.to_character_32, last_index + 1)
				end
				Result := index
				last_index := l_area.count
				l_area.extend (index.to_character_32)
				l_area.extend (index.to_character_32)
				l_area.extend (uc)
			else
				l_area.extend (uc)
				Result := a_last_upper + 1
			end
		end

	extend_z_code (a_z_code: NATURAL; a_last_upper, index: INTEGER): INTEGER
		do
			Result := extend (z_code_to_unicode (a_z_code).to_character_32, a_last_upper, index)
		end

	set_last_upper (a_last_upper: INTEGER)
		do
			if a_last_upper > 0 then
				area [last_index + 1] := a_last_upper.to_character_32
			end
		end

feature -- Removal

	wipe_out
		do
			area.wipe_out
			last_index := 0
		end

feature {NONE} -- Implementation

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