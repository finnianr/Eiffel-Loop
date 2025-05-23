note
	description: "[
		A list of substrings from a ${STRING_32} compacted into a single array of type
		
			area: ${SPECIAL [CHARACTER_32]}
			
		Each substring is preceded by two 32 bit characters representing the lower and upper index.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-26 7:47:27 GMT (Saturday 26th April 2025)"
	revision: "81"

deferred class
	EL_COMPACT_SUBSTRINGS_32_I

inherit
	EL_COMPACT_SUBSTRINGS_32_BASE
		export
			{EL_ZCODE_CONVERSION} is_valid, substring_list, Buffer
			{STRING_HANDLER} area
			{ANY} interval_sequence
		end

	EL_EXTENDED_READABLE_STRING_SELECTION

feature {NONE} -- Initialization

	make
		do
			set_area (Empty_unencoded)
		end

	make_filled (uc: CHARACTER_32; n: INTEGER)
		do
			set_area (new_filled_area (uc, n + 2))
			area.put ('%/1/', 0)
			area.put (n.to_character_32, 1)
		end

	make_joined (a, b: EL_COMPACT_SUBSTRINGS_32; offset: INTEGER)
		-- make `a' joined with `b' shifted `offset' places to right
		local
			i, lower, upper: INTEGER; l_area, area_a, area_b, current_area: like area
		do
			l_area := area; current_area := l_area
			area_a := a.area; area_b := b.area
			if area_a.count > 0 and area_b.count > 0 then
				i := a.last_index
				upper := area_a [i + 1].code
				if upper + 1 = b.first_lower + offset then
					-- merge intervals
					l_area := area_a.aliased_resized_area (area_a.count + area_b.count - 2)
					l_area.copy_data (area_b, 2, area_a.count, area_b.count - 2)
					upper := b.first_upper + offset
					put_upper (l_area, i, upper)
					i := i + upper - l_area [i].code + 3
				else
					i := area_a.count
					l_area := area_a.aliased_resized_area (area_a.count + area_b.count)
					l_area.copy_data (area_b, 0, l_area.count, area_b.count)
				end

			elseif area_a.count > 0 then
				if l_area /= area_a then
					l_area := area_a.twin
				end
				i := l_area.count

			elseif area_b.count > 0 then
				if l_area /= area_b then
					l_area := area_b.twin
				end
			end
			if offset.abs.to_boolean and then l_area.count > 0 then
				-- Shift offset places to right
				from until i = l_area.count loop
					lower := l_area [i].code; upper := l_area [i + 1].code
					put_lower (l_area, i, lower + offset)
					put_upper (l_area, i, upper + offset)
					i := i + upper - lower + 3
				end
			end
			set_if_changed (current_area, l_area)
		ensure
			valid_count: character_count = old (a.character_count + b.character_count)
		end

	make_from_other (other: EL_COMPACT_SUBSTRINGS_32_I)
		do
			if other.not_empty then
				set_area (other.area.twin)
			else
				make
			end
		end

	make_from_intervals (
		source: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]; interval_list: EL_ARRAYED_INTERVAL_LIST
		area_offset: INTEGER_32
	)
		local
			i, upper, lower: INTEGER; l_area: like area
		do
			create l_area.make_empty (interval_list.count_sum + interval_list.count * 2)
			if attached interval_list.area as interval_area then
				from until i = interval_area.count loop
					lower := interval_area [i]; upper := interval_area [i + 1]
					l_area.extend (lower.to_character_32)
					l_area.extend (upper.to_character_32)
					source.append_to (l_area, lower - area_offset - 1, upper - lower + 1)
					i := i + 2
				end
			end
			set_area (l_area)
		end

feature -- Access

	code (index: INTEGER): NATURAL
		require
			valid_index: index >= 1
		do
			Result := item (index).natural_32_code
		end

	count_greater_than_zero_flags (other: EL_COMPACT_SUBSTRINGS_32_I): like current_other_bitmap
		-- bitmap representing respective encodings
		do
			Result := current_other_bitmap (area.count > 0, other.area.count > 0)
		end

	current_other_bitmap (is_current, is_other: BOOLEAN): INTEGER
		-- combined booleans with values corresponding to
		-- `Both_have_mixed_encoding', `Only_current', `Only_other', `Neither'
		do
			Result := is_current.to_integer |<< 1 | is_other.to_integer
		end

	i_th_substring (index: INTEGER): detachable IMMUTABLE_STRING_32
		local
			i, j, lower, upper, count: INTEGER; l_area: like area
		do
			create Result.make (3)
			l_area := area
			from until j = index or i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				j := j + 1
				if j = index then
					Result := Immutable_32.new_substring (l_area, i + 2, count)
				end
				i := i + count + 2
			end
		end

	item (index: INTEGER): CHARACTER_32
		local
			i, lower, upper: INTEGER
		do
			if attached area as l_area then
				from until Result.code > 0 or else i = l_area.count loop
					lower := l_area [i].code; upper := l_area [i + 1].code
					if lower <= index and then index <= upper then
						Result := l_area [i + index - lower + 2]
					end
					i := i + upper - lower + 3
				end
			end
		end

	combined_area: like area
		-- all sub areas combined into one monolithic area
		local
			i, j, lower, upper: INTEGER; l_area: like area
		do
			create Result.make_empty (character_count)
			l_area := area
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				from j := lower until j > upper loop
					Result.extend (l_area.item (i + 2 + j - lower).to_character_32)
					j := j + 1
				end
				i := i + upper - lower + 3
			end
		end

	z_code (index: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (code (index))
		end

feature -- Index query

	first_lower: INTEGER
		local
			l_area: like area
		do
			l_area := area
			if l_area.count > 0 then
				Result := l_area.item (0).natural_32_code.to_integer_32
			end
		end

	first_upper: INTEGER
		local
			l_area: like area
		do
			l_area := area
			if l_area.count > 0 then
				Result := l_area.item (1).natural_32_code.to_integer_32
			end
		end

	last_index: INTEGER
			-- index into `area' of last interval
		local
			i, count: INTEGER
		do
			if attached area as l_area then
				from until i = l_area.count loop
					count := l_area [i + 1].code - l_area [i].code + 1
					i := i + count + 2
				end
				Result := i - count - 2
			end
		end

	last_upper: INTEGER
			-- count when substrings are expanded to original source string
		do
			if attached area as l_area and then l_area.count >= 2 then
				Result := l_area [last_index + 1].code
			end
		end

feature -- Search index

	index_of (uc: CHARACTER_32; start_index: INTEGER; block_index_ptr: TYPED_POINTER [INTEGER]): INTEGER
		local
			i, j, lower, upper, count: INTEGER; l_area: like area
			persistent_block_index: BOOLEAN
		do
			l_area := area
			persistent_block_index := not block_index_ptr.is_default_pointer
			if persistent_block_index then
				i := read_integer_32 (block_index_ptr)
			end
			from until Result > 0 or else i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				if start_index <= lower or else start_index <= upper then
					from j := lower.max (start_index) - lower + 1 until Result > 0 or else j > count loop
						if l_area [i + 1 + j] = uc then
							Result := lower + j - 1
						end
						j := j + 1
					end
				end
				if Result = 0 then
					i := i + count + 2
				end
			end
			if persistent_block_index then
				put_integer_32 (i, block_index_ptr)
			end
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		local
			i, j, k, lower, upper, count: INTEGER; l_area: like area
			list: like index_list; index_area: SPECIAL [INTEGER]
		do
			l_area := area; list := index_list; index_area := list.area
			from k := list.count - 1 until Result > 0 or else k < 0 loop
				i := index_area [k]
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				if upper <= start_index_from_end or else lower <= start_index_from_end then
					from j := upper.min (start_index_from_end) - lower + 1 until Result > 0 or else j = 0 loop
						if l_area [i + 1 + j] = uc then
							Result := lower + j - 1
						end
						j := j - 1
					end
				end
				k := k - 1
			end
		end

feature -- Measurement

	substring_count: INTEGER
		-- count of substrings
		local
			i: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until i = l_area.count loop
				Result := Result + 1
				i := i + section_count (l_area, i) + 2
			end
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			i, j, count: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until i = l_area.count loop
				count := section_count (l_area, i)
				from j := 1 until j > count loop
					if l_area [i + 1 + j] = uc then
						Result := Result + 1
					end
					j := j + 1
				end
				i := i + count + 2
			end
		end

	character_count: INTEGER
		-- sum of each substring count
		local
			i, count: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until i = l_area.count loop
				count := section_count (l_area, i)
				Result := Result + count
				i := i + count + 2
			end
		end

	extended_hash_code (seed, end_index: INTEGER): INTEGER
		-- extended hash code value based on `seed' value up to `end_index'
		local
			i, offset, count, lower, upper: INTEGER; break: BOOLEAN
			b: EL_BIT_ROUTINES
		do
			Result := seed
			if attached area as l_area then
				from i := 0 until i = l_area.count or break loop
					lower := l_area [i].code; upper := l_area [i + 1].code
					if lower > end_index then
						break := True
					else
						if upper > end_index then
							upper := end_index
							break := True
						end
						count := upper - lower + 1
						from i := i + 2; offset := 0 until offset = count loop
							Result := b.extended_hash (Result, l_area.item (i + offset).code)
							offset := offset + 1
						end
						i := i + count
					end
				end
			end
		end

	intersection_count (lower_A, upper_A: INTEGER): INTEGER
		-- count of characters between `lower_A' and `upper_A'
		local
			overlapping: BOOLEAN; ir: EL_INTERVAL_ROUTINES; l_area: like area
			i, lower_B, upper_B: INTEGER
		do
			l_area := area; overlapping := True
			from
				i := index_of_overlapping (l_area, lower_A, upper_A)
			until
				not overlapping or else i = l_area.count
			loop
				lower_B := l_area [i].code; upper_B := l_area [i + 1].code
				inspect ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					when B_contains_A then
						Result := upper_A - lower_A + 1
					when A_contains_B then
						Result := Result + upper_B - lower_B + 1
					when A_overlaps_B_left then
						Result := Result + upper_A - lower_B + 1
					when A_overlaps_B_right then
						Result := Result + upper_B - lower_A + 1
				else
					overlapping := False
				end
				i := i + upper_B - lower_B + 3
			end
		end

	utf_8_byte_count: INTEGER
		local
			i, j, count: INTEGER; uc: EL_UC_ROUTINES
		do
			if attached area as l_area then
				from i := 0 until i = l_area.count loop
					count := section_count (l_area, i)
					from j := 1 until j > count loop
						Result := Result + uc.utf_8_byte_count (l_area [i + 1 + j].natural_32_code)
						j := j + 1
					end
					i := i + count + 2
				end
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		do
			Result := index_of (uc, 1, null) > 0
		end

	has_between (uc: CHARACTER_32; lower_A, upper_A: INTEGER): BOOLEAN
		local
			overlapping: BOOLEAN; l_area: like area
			i, j, lower_B, upper_B, l_count, offset, comparison_count, j_final: INTEGER
			ir: EL_INTERVAL_ROUTINES
		do
			l_area := area; overlapping := True
			from
				i := index_of_overlapping (l_area, lower_A, upper_A)
			until
				not overlapping or Result or i = l_area.count
			loop
--				[lower_A, upper_A] is A interval
				lower_B := l_area [i].code; upper_B := l_area [i + 1].code -- is B interval
				l_count := upper_B - lower_B + 1

				inspect ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					when B_contains_A then
						comparison_count := upper_A - lower_A + 1
						offset := lower_A - lower_B

					when A_contains_B then
						comparison_count := upper_B - lower_B + 1
						offset := 0

					when A_overlaps_B_left then
						comparison_count := upper_A - lower_B + 1
						offset := 0

					when A_overlaps_B_right then
						comparison_count := upper_B - lower_A + 1
						offset := lower_A - lower_B

				else
					overlapping := False
				end
				if overlapping then
					j := i + 2 + offset; j_final := j + comparison_count
					from until Result or j = j_final loop
						Result := l_area [j] = uc
						j := j + 1
					end
				end
				i := i + l_count + 2
			end
		end

	intersects (lower_A, upper_A: INTEGER): BOOLEAN
		-- `True' if some characters are between `lower_A' and `upper_A'
		do
			if upper_A >= lower_A and then attached area as l_area then
				Result := index_of_overlapping (l_area, lower_a, upper_a) /= l_area.count
			end
		end

	overlaps (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := not (end_index < first_lower) and then not (start_index > last_upper)
		end

feature -- Comparison

	same_characters (other_area: like area; lower_A, upper_A, other_offset: INTEGER; case_insensitive: BOOLEAN): BOOLEAN
		local
			i, lower_B, upper_B, l_count, offset, comparison_count, other_block_index: INTEGER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; ir: EL_INTERVAL_ROUTINES
			overlapping: BOOLEAN; l_area: like area
		do
			l_area := area
			Result := True; overlapping := True
			from
				i := index_of_overlapping (l_area, lower_A, upper_A)
			until
				not overlapping or not Result or i = l_area.count
			loop
--				[lower_A, upper_A] is A interval
				lower_B := l_area [i].code; upper_B := l_area [i + 1].code -- is B interval
				l_count := upper_B - lower_B + 1

				inspect ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
					when A_overlaps_B_left then
						comparison_count := upper_A - lower_B + 1
						offset := 0

					when A_overlaps_B_right then
						comparison_count := upper_B - lower_A + 1
						offset := lower_A - lower_B

					when A_contains_B then
						comparison_count := upper_B - lower_B + 1
						offset := 0

					when B_contains_A then
						comparison_count := upper_A - lower_A + 1
						offset := lower_A - lower_B

				else
					overlapping := False
				end
				if overlapping then
					if case_insensitive then
						Result := iter.same_caseless_characters (
							$other_block_index, other_area, l_area,
							lower_B + offset + other_offset, i + 2 + offset, comparison_count
						)
					else
						Result := iter.same_characters (
							$other_block_index, other_area, l_area,
							lower_B + offset + other_offset, i + 2 + offset, comparison_count
						)
					end
				end
				i := i + l_count + 2
			end
		end

	same_string (other: EL_COMPACT_SUBSTRINGS_32_I): BOOLEAN
		local
			l_area: like area
		do
			l_area := area
			if l_area.count = other.area.count then
				Result := l_area.same_items (other.area, 0, 0, l_area.count)
			end
		end

feature -- Element change

	append (other: EL_COMPACT_SUBSTRINGS_32_I; offset: INTEGER)
		local
			i, capacity, lower, upper: INTEGER; l_area: like area
		do
			l_area := area
			if attached other.area as o_area then
				if l_area.count > 0 and o_area.count > 0 then
					i := last_index; capacity := l_area.capacity
					upper := l_area [i + 1].code
					if upper + 1 = other.first_lower + offset then
						-- merge intervals
						l_area := big_enough (l_area, o_area.count - 2)
						l_area.copy_data (o_area, 2, l_area.count, o_area.count - 2)
						upper := other.first_upper + offset
						l_area [i + 1] := upper.to_character_32
						i := i + upper - l_area [i].code + 3
					else
						i := l_area.count
						l_area := big_enough (l_area, o_area.count)
						l_area.copy_data (o_area, 0, l_area.count, o_area.count)
					end
					if l_area.capacity > capacity then
						set_area (l_area)
					end

				elseif o_area.count > 0 then
					l_area := o_area.twin
					set_area (l_area)
				end
				if offset.abs.to_boolean and then l_area.count > 0 then
					-- Shift offset places to right
					from until i = l_area.count loop
						lower := l_area [i].code + offset; upper := l_area [i + 1].code + offset
						l_area [i] := lower.to_character_32
						l_area [i + 1] := upper.to_character_32
						i := i + upper - lower + 3
					end
				end
			end
		ensure
			valid_count: character_count = old character_count + other.character_count
		end

	append_intervals (
		source: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]; interval_list: EL_ARRAYED_INTERVAL_LIST
		area_offset: INTEGER_32
	)
		require
			not_empty: not_empty
			at_least_one_interval: interval_list.count > 0
		local
			i, l_last_index, upper, lower, additional_count: INTEGER; l_area: like area
			merge_with_last: BOOLEAN
		do
			additional_count := interval_list.count_sum + interval_list.count * 2
			l_last_index := last_index; l_area := area
			upper := l_area [l_last_index + 1].code
			if upper + 1 = interval_list.first_lower then
				merge_with_last := True
				additional_count := additional_count - 2
				l_area [l_last_index + 1] := interval_list.first_upper.to_character_32
			end
			l_area := l_area.resized_area (l_area.count + additional_count)

			if attached interval_list.area as interval_area then
				from until i = interval_area.count loop
					lower := interval_area [i]; upper := interval_area [i + 1]
					if merge_with_last implies i > 0 then
						l_area.extend (lower.to_character_32)
						l_area.extend (upper.to_character_32)
					end
					source.append_to (l_area, lower - area_offset - 1, upper - lower + 1)
					i := i + 2
				end
			end
			set_area (l_area)
		end

	insert (other: EL_COMPACT_SUBSTRINGS_32_I)
		require
			no_overlap: not interval_sequence.overlaps (other.interval_sequence)
		local
			i, previous_i, lower, upper, previous_upper, count, i_final: INTEGER
			other_lower, other_last_upper, other_array_count: INTEGER
			l_area, current_area, other_unencoded: like area; other_inserted: BOOLEAN
		do
			l_area := area; current_area := l_area; i_final := l_area.count
			other_unencoded := other.area; other_array_count := other_unencoded.count
			other_lower := other.first_lower; other_last_upper := other.last_upper
			from i := 0 until i = i_final loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				if not other_inserted and then previous_upper < other_lower and then other_last_upper < lower then
					-- Insert other
					l_area := big_enough (area, other_array_count)
					l_area.insert_data (other_unencoded, 0, i, other_array_count)
					i_final := i_final + other_array_count
					lower := l_area [i].code; upper := l_area [i + 1].code
					count := upper - lower + 1
					other_inserted := True
				end
				if other_inserted and then previous_upper > 0 and then previous_upper + 1 = lower then
					-- Merge intervals that are continous with previous
					l_area.overlapping_move (i + 2, i, l_area.count - i - 2)
					l_area.remove_tail (2)
					i := previous_i; upper := previous_upper + count
					lower := l_area [i].code
					l_area.put (upper.to_character_32, i + 1)
					count := upper - lower + 1
					i_final := i_final - 2
				end
				previous_upper := upper
				previous_i := i
				i := i + count + 2
			end
			set_if_changed (current_area, l_area)
			if not other_inserted then
				append (other, 0)
			end
		end

	put (uc: CHARACTER_32; index: INTEGER)
		local
			i, previous_i, previous_upper, lower, upper, count, i_final: INTEGER; found: BOOLEAN
			l_area, current_area: like area
		do
			l_area := area; current_area := l_area; i_final := l_area.count
			from until found or i = i_final loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				if lower <= index and then index <= upper then
					-- update interval
					l_area.put (uc, i + 2 + index - lower)
					found := True
				elseif upper + 1 = index then
					-- extend interval right
					count := count + 1
					l_area := extended_enough (l_area, i + count + 1, 0, 0, uc)
					l_area.put (index.to_character_32, i + 1)
					found := True
				elseif lower - 1 = index then
					-- extend interval left
					count := count + 1
					lower := lower - 1
					l_area := extended_enough (l_area, i + 2, 0, 0, uc)
					l_area.put (index.to_character_32, i)
					found := True

				elseif previous_upper < index and then index < lower then
					-- insert a new interval
					l_area := extended_enough (l_area, previous_i, index, index, uc)
					i := i + 3
					found := True
				end
				if previous_upper > 0 and then previous_upper + 1 = lower then
					-- Merge interval with previous
					l_area.overlapping_move (i + 2, i, l_area.count - i - 2)
					l_area.remove_tail (2)
					i := previous_i; upper := previous_upper + count
					lower := l_area [i].code
					l_area.put (upper.to_character_32, i + 1)
					count := upper - lower + 1
					i_final := i_final - 2
				end
				previous_upper := upper; previous_i := i
				i := i + count + 2
			end
			if not found then
				-- append a new interval
				l_area := extended_enough (l_area, l_area.count, index, index, uc)
			end
			set_if_changed (current_area, l_area)
		ensure
			code_set: item (index) = uc
		end

	set_from_buffer (a_area: EL_COMPACT_SUBSTRINGS_32_BUFFER)
		do
			if a_area.not_empty then
				set_area (a_area.area_copy)
			else
				set_area (Empty_unencoded)
			end
		ensure
			is_valid: is_valid
		end

	shift (offset: INTEGER)
		-- shift intervals right by `offset' characters. `offset' < 0 shifts to the left.
		do
			shift_from (1, offset)
		end

	shift_from (a_index, offset: INTEGER)
		-- shift intervals right by `offset' characters starting from `index'.
		-- Split if interval has `index' and `index' > `lower'
		-- `offset < 0' shifts to the left.
		local
			i, index, lower, upper, count, capacity: INTEGER; l_area: like area
		do
			if offset /= 0 then
				l_area := area; capacity := l_area.capacity
				index := a_index + offset
				from i := 0 until i = l_area.count loop
					lower := l_area [i].code + offset; upper := l_area [i + 1].code + offset
					count := upper - lower + 1
					if index <= lower then
						l_area [i] := lower.to_character_32
						l_area [i + 1] := upper.to_character_32

					elseif lower < index and then index <= upper then
						-- Split the interval in two
						l_area [i + 1] := (a_index - 1).to_character_32
						l_area := extended_enough (l_area, i + 2 + index - lower, index, upper, '%U')
						i := i + 2
					end
					i := i + count + 2
				end
				if l_area.capacity > capacity  then
					set_area (l_area)
				end
			end
		end

	to_lower
		do
			change_case (True)
		end

	to_upper
		do
			change_case (False)
		end

feature -- Removal

	replace_character (uc_old, uc_new: CHARACTER_32; shift_remaining: BOOLEAN)
		-- replace all `uc_old' with `uc_new' and shifting to left if `shift_remaining = True'
		-- if `uc_new = 0' then remove `uc_old'
		local
			i, j, lower, upper, count, i_final, previous_i, delta: INTEGER
			l_area: like area; found: BOOLEAN; l_code: CHARACTER_32; l_last_upper: INTEGER
		do
			previous_i := (1).opposite
			l_area := area; i_final := l_area.count
			from i := 0 until found or else i = i_final loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				from j := 1 until found or else j > count loop
					if l_area [i + 1 + j] = uc_old then
						found := True
					else
						j := j + 1
					end
				end
				if not found then
					previous_i := i
					i := i + count + 2
				end
			end
			if found and then attached empty_buffer as l_buffer then
				if previous_i >= 0 then
					l_buffer.append_from_area (l_area, previous_i)
				end
				from l_last_upper := l_buffer.last_upper until i = i_final loop
					lower := l_area [i].code; upper := l_area [i + 1].code
					from j := lower until j > upper loop
						l_code := l_area [i + 2 + j - lower]
						if l_code = uc_old then
							inspect uc_new
								when '%U' then
									delta := delta + shift_remaining.to_integer
							else
								l_last_upper := l_buffer.extend (uc_new, l_last_upper, j)
							end
						else
							l_last_upper := l_buffer.extend (l_code, l_last_upper, j - delta)
						end
						j := j + 1
					end
					i := i + upper - lower + 3
				end
				l_buffer.set_last_upper (l_last_upper)

				set_from_buffer (l_buffer)
			end
		end

	remove (index: INTEGER)
		local
			i, lower, upper, count, i_final, removed_count, source_index, destination_index: INTEGER
			l_area, current_area: like area; found: BOOLEAN
		do
			l_area := area; current_area := l_area; i_final := l_area.count
			from i := 0 until found or else i = i_final loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				if lower = index or else index = upper then
					if count = 1 then
						removed_count := 3
						destination_index := i; source_index := i + 3
					else
						destination_index := i + 2 + index - lower; source_index := destination_index + 1
						removed_count := 1
					end
					l_area.overlapping_move (source_index, destination_index, l_area.count - source_index)
					l_area.remove_tail (removed_count)
					if removed_count = 1 then
						if index = lower then
							l_area.put ((lower + 1).to_character_32, i)
						else
							l_area.put ((upper - 1).to_character_32, i + 1)
						end
					end
					found := True
				elseif lower < index and index < upper then
					-- Split interval in two
					destination_index := i + 2 + index - lower
					l_area := extended_enough (l_area, destination_index, index + 1, 0, '%U')
					put_upper (l_area, destination_index, upper)
					put_upper (l_area, i, index - 1)
					found := True
				end
				i := i + count + 2
			end
			set_if_changed (current_area, l_area)
		end

	remove_indices (list: like index_list)
		local
			i, j, i_final, pruned_count, lower, upper, l_last_upper: INTEGER
			l_area: like area
		do
			l_area := area; i_final := area.count
			if not list.is_empty and then i_final > 0 then
				if attached empty_buffer as l_buffer then
					l_last_upper := l_buffer.last_upper
					from i := 0; list.start until i = i_final loop
						lower := l_area [i].code; upper := l_area [i + 1].code
						from until list.after or else list.item >= lower loop
							list.forth
							pruned_count := pruned_count + 1
						end
						from j := lower until j > upper loop
							if not list.after and then list.item = j then
								pruned_count := pruned_count + 1
								list.forth
							else
								l_last_upper := l_buffer.extend (l_area [i + 2 + j - lower], l_last_upper, j - pruned_count)
							end
							j := j + 1
						end
						i := i + upper - lower + 3
					end
					l_buffer.set_last_upper (l_last_upper)
					set_from_buffer (l_buffer)
				end
			end
		end

	remove_substring (lower_A, upper_A: INTEGER)
		require
			interval_count_not_zero: upper_A >= lower_A
		local
			i, lower_B, upper_B, i_final, overlap_status, previous_i, previous_upper: INTEGER
			count, removed_count, deleted_count, start_index, end_index: INTEGER
			ir: EL_INTERVAL_ROUTINES; l_area: like area
		do
			l_area := area; i_final := l_area.count
			deleted_count := upper_A - lower_A + 1
			from i := 0 until i = i_final loop
				lower_B := l_area [i].code; upper_B := l_area [i + 1].code
				count := upper_B - lower_B + 1
				removed_count := 0
				overlap_status := ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
				inspect overlap_status
					when B_contains_A then
						-- Remove middle section
						start_index := lower_A; end_index := upper_A
					when A_contains_B then
						-- Remove entire section
						start_index := lower_B; end_index := upper_B
					when A_overlaps_B_left then
						-- Remove leading section
						start_index := lower_B; end_index := upper_A
					when A_overlaps_B_right then
						-- Remove trailing section
						start_index := lower_A; end_index := upper_B
					when A_left_of_B then
						l_area [i] := (lower_B - deleted_count).to_character_32
						l_area [i + 1] := (upper_B - deleted_count).to_character_32
						start_index := 0
				else
					start_index := 0
				end
				if start_index.to_boolean then
					removed_count := remove_section (l_area, i, lower_B, upper_B, start_index, end_index, deleted_count)
				end
				if removed_count > 0 then
					if removed_count = count + 2 then
						-- Section removed
						i_final := i_final - removed_count
						if i_final = 0 then
							set_area (Empty_unencoded)
						end
					else
						lower_B := l_area [i].code; upper_B := l_area [i + 1].code
						if previous_upper > 0 and then previous_upper + 1 = lower_B then
							-- Merge interval with previous
							l_area.overlapping_move (i + 2, i, l_area.count - i - 2)
							l_area.remove_tail (2)
							i := previous_i
							lower_B := l_area [i].code
							l_area.put (upper_B.to_character_32, i + 1)
							count := upper_B - lower_B + 1
							i_final := i_final - removed_count - 2
							removed_count := 0
						else
							i_final := i_final - removed_count
						end
					end
				end
				previous_i := i; previous_upper := upper_B
				i := i + count + 2 - removed_count
			end
		end

feature -- Basic operations

	fill (str_32: STRING_32)
			-- write substrings into expanded string 'str'
		local
			i, j, lower, upper: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				from j := lower until j > upper loop
					str_32.extend (l_area.item (i + 2 + j - lower))
					j := j + 1
				end
				i := i + upper - lower + 3
			end
		end

	fill_list (list: LIST [IMMUTABLE_STRING_32])
		local
			i, lower, upper, count: INTEGER; l_area: like area
		do
			l_area := area
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				count := upper - lower + 1
				list.extend (Immutable_32.new_substring (l_area, i + 2, count))
				i := i + count + 2
			end
		end

	re_encode_intervals (codec: EL_ZCODEC; interval_list: EL_ARRAYED_INTERVAL_LIST)
		require
			contains_all_intervals: contains_all_intervals (interval_list)
		local
			i, j, k, lower_A, upper_A, lower_B, upper_B, j_upper: INTEGER
			unicode: SPECIAL [CHARACTER_32]; ir: EL_INTERVAL_ROUTINES; l_area: like area
			done: BOOLEAN; uc: CHARACTER_32
		do
			if interval_list.count > 0 then
				unicode := codec.unicode_table; l_area := area
				interval_list.start
				from
					i := index_of_overlapping (l_area, lower_A, upper_A)
				until
					done or else i = l_area.count
				loop
					lower_B := l_area [i].code; upper_B := l_area [i + 1].code
					lower_A := interval_list.item_lower; upper_A := interval_list.item_upper

					inspect ir.overlap_status (lower_A, upper_A, lower_B, upper_B)
						when B_contains_A then
							j_upper := i + 2 + upper_A - lower_B
							from j := i + 2 + lower_A - lower_B until j > j_upper loop
								uc := area [j]
								k := uc.code
								if unicode.valid_index (k) then
									area [j] := unicode [k]
								else
									area [j] := Replacement_character
								end
								j := j + 1
							end
							interval_list.forth
							done := interval_list.after
					else
						done := True
					end
					i := i + upper_B - lower_B + 3
				end
			end
		end

	write (area_out: SPECIAL [CHARACTER_32]; offset, end_index: INTEGER; as_zcode: BOOLEAN)
		-- write substrings into expanded string 'str'
		-- if `as_zcode' is `True' write characters as `unicode_to_z_code'
		require
			string_big_enough: last_upper + offset <= area_out.count
		local
			i, j, lower, upper: INTEGER; uc: CHARACTER_32; break: BOOLEAN
		do
			if attached area as l_area then
				from i := 0 until i = l_area.count or break loop
					lower := l_area [i].code; upper := l_area [i + 1].code
					if lower > end_index then
						break := True
					else
						if upper > end_index then
							upper := end_index
							break := True
						end
						if as_zcode then
							from j := lower until j > upper loop
								uc := l_area.item (i + 2 + j - lower)
								if uc.natural_32_code <= 0xFF then
									uc := (Sign_bit | uc.natural_32_code).to_character_32
								end
								area_out [offset + j - 1] := uc
								j := j + 1
							end
						else
							from j := lower until j > upper loop
								area_out [offset + j - 1] := l_area.item (i + 2 + j - lower)
								j := j + 1
							end
						end
						i := i + upper - lower + 3
					end
				end
			end
		end

feature -- Duplication

	shifted (offset: INTEGER): EL_COMPACT_SUBSTRINGS_32
		do
			create Result.make_from_other (Current)
			Result.shift (offset)
		end

feature {NONE} -- Constants

	Shared_super_readable_32: EL_READABLE_STRING_32
		once
			create Result.make_empty
		end

	Shared_super_readable_8: EL_READABLE_STRING_8
		once
			create Result.make_empty
		end

	Shared_super_readable_z: EL_EXTENDED_ZSTRING
		once
			create Result.make_empty
		end

note
	notes: "[
		Benchmark 23 Dec 2023

		Tried caching offset to [upper, lower] for substrings in `block_offset' but got inferior benchmarks
		when compared to ${STRING_32}. So reverted to uncached.

			  cached: "$B $C"       9887  +43%
			uncached: "$B $C"       13269	+21%

			  cached: "$A $B $C $D"	1316  +13%
			uncached: "$A $B $C $D"	1483  1481
			
		But this is probably only for short strings. Made duplicity backup with this date in case I decide
		to reinstate caching which did infact pass all tests.
	]"

end