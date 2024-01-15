note
	description: "[
		Array of sequential substrings from an instance of [$source STRING_32] compacted into a single
		[$source SPECIAL] array:
		
			area: [$source SPECIAL [NATURAL]]
			
		`area [0]' contains the substring count: `count'
		
		`area [1] -> area [count * 2]' contains a series of `count' interval specifications `[lower, upper]'
		
		`area [count * 2 + 1] -> area [area.count - 1]' contains the combined substring character data
	]"
	notes: "[
		Tried an experiment in Jan 2021 to implement [$source EL_ZSTRING] using [$source EL_SUBSTRING_32_ARRAY]
		instead of [$source EL_COMPACT_SUBSTRINGS_32]. It passed all the tests but the performance benchmarks
		indicated that it was on average significantly slower the original [$source EL_COMPACT_SUBSTRINGS_32]
		implementation.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 12:28:38 GMT (Monday 15th January 2024)"
	revision: "25"

class
	EL_SUBSTRING_32_ARRAY

inherit
	EL_SUBSTRING_32_ARRAY_IMPLEMENTATION
		export
			{ANY} valid_index
		end

	EL_SUBSTRING_32_CONTAINER

create
	make_empty, make_from_area, make_from_other, make_from_unencoded

convert
	make_from_unencoded ({ZSTRING})

feature {NONE} -- Initialization

	make_empty
		do
			area := Empty_area
		end

	make_filled (uc: CHARACTER_32; n: INTEGER)
		do
			create area.make_filled (uc, n + 3)
			area [0] := '%/1/'
			area [1] := '%/1/'
			area [2] := n.to_character_32
		ensure
			valid_array: is_valid
		end

	make_from_area (a_area: like area)
		require
			area_has_count: a_area.count > 0
		do
			if a_area [0] > '%U' then
				area := a_area
			else
				make_empty
			end
		ensure
			valid_array: is_valid
		end

	make_from_unencoded (unencoded: EL_COMPACT_SUBSTRINGS_32)
		local
			i, lower, upper, l_count, char_count, offset: INTEGER
			l_area: like area
		do
			l_count := unencoded.substring_count
			create area.make_empty (l_count * 2 + unencoded.character_count + 1)
			area.extend (l_count.to_character_32)

			l_area := unencoded.area
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				area.extend (lower.to_character_32); area.extend (upper.to_character_32);
				char_count := upper - lower + 1
				i := i + char_count + 2
			end
			offset := l_count * 2  + 1 -- substring offset
			from i := 0 until i = l_area.count loop
				lower := l_area [i].code; upper := l_area [i + 1].code
				char_count := upper - lower + 1
				area.copy_data (l_area, i + 2, offset, char_count)
				offset := offset + char_count
				i := i + char_count + 2
			end
		end

	make_from_other (other: EL_SUBSTRING_32_ARRAY)
		do
			if other.count.to_boolean then
				area := other.area.twin
			else
				make_empty
			end
		end

feature -- Access

	area: SPECIAL [CHARACTER_32]

	code (index: INTEGER): NATURAL
		do
			Result := item (index).natural_32_code
		end

	count_greater_than_zero_flags (other: EL_SUBSTRING_32_CONTAINER): INTEGER
		do
			Result := (count.to_boolean.to_integer |<< 1) | other.count.to_boolean.to_integer
		end

	first_lower: INTEGER
		require
			not_empty: not_empty
		do
			if count.to_boolean then
				Result := area [1].code
			end
		end

	first_upper: INTEGER
		require
			not_empty: not_empty
		do
			if count.to_boolean then
				Result := area [2].code
			end
		end

	hash_code (seed: INTEGER): INTEGER
			-- Hash code value
		local
			i, i_final: INTEGER; b: EL_BIT_ROUTINES
		do
			if attached area as l_area then
				i_final := first_index (l_area) + character_count
				Result := seed
				from i := first_index (l_area) until i = i_final loop
					Result := b.extended_hash (Result, l_area [i].code)
					i := i + 1
				end
			end
		end

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			i, j, lower, upper, offset, char_count, i_final: INTEGER; l_area: like area
			found: BOOLEAN
		do
			l_area := area; i_final := first_index (l_area)
			offset := i_final
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				if start_index <= lower or else start_index <= upper then
					from j := lower.max (start_index) - lower + 1 until found or else j > char_count loop
						if l_area [offset + j - 1] = uc then
							Result := lower + j - 1
							found := True
						end
						j := j + 1
					end
				end
				offset := offset + char_count
				i := i + 2
			end
		end

	item (index: INTEGER): CHARACTER_32
		require
			valid_index: valid_index (index)
		local
			i, lower, upper, i_final, offset: INTEGER; l_area: like area
			found: BOOLEAN
		do
			l_area := area; i_final := first_index (l_area)
			offset := i_final
			from i := 1 until found or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= index and then index <= upper then
					Result := l_area [offset + index - lower]
					found := True
				end
				offset := offset + upper - lower + 1
				i := i + 2
			end
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		local
			i, j, lower, upper, offset, char_count, i_final: INTEGER; l_area: like area
			found: BOOLEAN
		do
			l_area := area; i_final := first_index (l_area)
			offset := i_final + character_count
			from i := i_final - 2 until found or else i < 0 loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				offset := offset - char_count
				if upper <= start_index_from_end or else lower <= start_index_from_end then
					from j := upper.min (start_index_from_end) - lower + 1 until found or else j = 0 loop
						if l_area [offset + j - 1] = uc then
							Result := lower + j - 1
							found := True
						end
						j := j - 1
					end
				end
				i := i - 2
			end
		end

	last_lower: INTEGER
		-- index of first character in last substring
		require
			not_empty: not_empty
		do
			Result := area [count * 2 - 1].code
		end

	last_upper: INTEGER
		-- index of last character in last substring
		require
			not_empty: not_empty
		do
			Result := area [count * 2].code
		end

	sub_array (start_index, end_index: INTEGER): EL_SUBSTRING_32_ARRAY
		local
			i, lower, upper, offset, char_count, l_count, l_character_count, i_final: INTEGER
			array_start_index, array_end_index, l_first_lower, l_last_upper: INTEGER
			l_area, sub_area: like area
		do
			l_area := area; i_final := first_index (l_area)
			offset := i_final
			from i := 1 until array_end_index.to_boolean or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				if array_start_index.to_boolean then
					-- searching for end
					if lower <= end_index and then end_index <= upper then
						array_end_index := i
						l_character_count := l_character_count + end_index - lower + 1
						l_last_upper := end_index
					elseif end_index < lower then
						l_last_upper := upper_bound (l_area, i - 2)
						array_end_index := i - 2
					else
						l_character_count := l_character_count + char_count
					end
				else
					-- searching for start
					if end_index < lower then
						-- is empty subarray
						i := i_final - 2 -- exit the loop

					elseif lower <= start_index and then start_index <= upper then
						-- partially contained
						array_start_index := i
						l_first_lower := start_index
						offset := offset + start_index - lower
						l_character_count := upper - start_index + 1
					elseif start_index < lower then
						-- fully contained
						array_start_index := i
						l_first_lower := lower
						l_character_count := char_count
					else
						offset := offset + char_count
					end
					if array_start_index.to_boolean and then end_index <= upper then
						-- contained in first
						l_character_count := end_index - l_first_lower + 1
						l_last_upper := end_index
						array_end_index := i
					end
				end
				i := i + 2
			end
			if array_start_index.to_boolean then
				l_count := (array_end_index - array_start_index) // 2 + 1
				sub_area := new_area (l_count, l_character_count)
				sub_area [0] := l_count.to_character_32
				sub_area.copy_data (l_area, array_start_index, 1, l_count * 2)
				put_lower (sub_area, 1, l_first_lower)
				put_upper (sub_area, l_count * 2 - 1, l_last_upper)

				sub_area.copy_data (l_area, offset, l_count * 2 + 1, l_character_count)
				create Result.make_from_area (sub_area)
			else
				create Result.make_empty
			end
		end

	z_code (index: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (code (index))
		end

feature -- Measurement

	character_count: INTEGER
		-- sum of all substring counts
		do
			Result := area.count - (count * 2 + 1)
		end

	count: INTEGER
		-- substring count
		do
			Result := area.item (0).code
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			i, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := first_index (l_area) + character_count
			from i := first_index (l_area) until i = i_final loop
				if l_area [i] = uc then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	utf_8_byte_count: INTEGER
		local
			i, i_final: INTEGER; l_area: like area; l_code: NATURAL
		do
			l_area := area; i_final := first_index (l_area) + character_count
			from i := first_index (l_area) until i = i_final loop
				l_code := l_area [i].natural_32_code
				if l_code <= 0x7F then
				-- 0xxxxxxx.
					Result := Result + 1
				elseif l_code <= 0x7FF then
				-- 110xxxxx 10xxxxxx
					Result := Result + 2
				elseif l_code <= 0xFFFF then
				-- 1110xxxx 10xxxxxx 10xxxxxx
					Result := Result + 3
				else
				-- l_code <= 1FFFFF - there are no higher code points
				-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
					Result := Result + 4
				end
				i := i + 1
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		do
			Result := index_of (uc, 1) > 0
		end

feature -- Comparison

	same_string (other: EL_SUBSTRING_32_ARRAY): BOOLEAN
		local
			l_area: like area
		do
			if Current = other then
				Result := True

			elseif count = other.count then
				l_area := area
				if l_area.count = other.area.count then
					Result := l_area.same_items (other.area, 0, 0, l_area.count)
				end
			end
		end

	same_substring (other: EL_SUBSTRING_32_ARRAY; a_start_index: INTEGER): BOOLEAN
		-- True if characters in `other' are unencoded at the same
		-- positions as `Current' starting at `start_index'
		local
			i, lower, upper, start_index, i_final, offset, trailing_count: INTEGER -- for `current'
			o_i, o_final, o_lower, o_upper, o_offset, o_start_index: INTEGER -- for `other'
			found: BOOLEAN; l_area, o_area: like area
		do
			if other.count = 0 then
				Result := True

			elseif not_empty then
				l_area := area; i_final := first_index (l_area); offset := i_final
				-- find `start_index'
				from i := 1 until found or else i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					if a_start_index <= lower then
						start_index := lower
						found := True

					elseif lower < a_start_index and then a_start_index <= upper then
						start_index := a_start_index
						found := True
					else
						offset := offset + upper - lower + 1
						i := i + 2
					end
				end
				if found then
					offset := offset + start_index - lower
					trailing_count := character_count - (offset - i_final)
					if other.count <= trailing_count then
						o_final := first_index (other.area); o_offset := o_final
						Result := area.same_items (other.area, o_offset, offset, other.count)
					end
				end
			else
				Result := start_index = 1 and other.count = 0
			end
			if Result then
				-- check for same absolute intervals
				o_start_index := other.first_lower; o_area := other.area
				from o_i := 1 until not Result or else o_i = o_final or else i = i_final loop
					o_lower := lower_bound (o_area, o_i) - o_start_index
					o_upper := upper_bound (o_area, o_i) - o_start_index
					if o_i = 1 then
						lower := 0
					else
						lower := lower_bound (l_area, i) - start_index
					end
					if o_i + 2 = o_final then
						-- is last interval of other
						upper := (upper_bound (l_area, i) - start_index).min (o_upper)
					else
						upper := upper_bound (l_area, i) - start_index
					end
					Result := lower = o_lower and then upper = o_upper
					i := i + 2; o_i := o_i + 2
				end
				Result := Result and o_i = o_final
			end
		end

feature -- Status change

	shift (n: INTEGER)
		-- shift intervals right by n characters. n < 0 shifts to the left.
		do
			shift_from (1, n)
		end

	shift_from (index, n: INTEGER)
		-- shift intervals right by `n' characters starting from `index'.
		-- Split if interval has `index' and `index' > `lower'
		-- n < 0 shifts to the left.
		local
			i, lower, upper, split_i, i_final, next_i: INTEGER; l_area: like area
		do
			if n.abs.to_boolean then
				l_area := area; i_final := first_index (l_area)
				-- search for split
				from i := 1 until split_i.to_boolean or else i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					if lower < index and then index <= upper then
						split_i := i
					end
					i := i + 2
				end
				if split_i.to_boolean then
					i := split_i; next_i := i + 2

					create l_area.make_empty (l_area.count + 2)
					l_area.copy_data (area, 0, 0, next_i)
					l_area.fill_with ('%U', next_i, next_i + 1)
					l_area.copy_data (area, next_i, next_i + 2, area.count - next_i)
					area := l_area

					put_upper (l_area, i, index - 1)
					put_interval (l_area, i + 2, index, upper)
					increment_count (l_area, 1)
					i_final := i_final + 2
				end
				from i := 1 until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					if index <= lower then
						put_interval (l_area, i, lower + n, upper + n)
					end
					i := i + 2
				end
			end
		ensure
			valid_array: is_valid
		end

	to_lower
		do
			change_case (True)
		end

	to_upper
		do
			change_case (False)
		end

feature -- Element change

	append_buffer (buffer: EL_SUBSTRING_32_BUFFER)
		require
			appendable: buffer.substring_count > 0 implies last_upper < buffer.first_lower
		local
			l_area, buffer_area: like area; merge_first: BOOLEAN
			offset, new_count, i, i_final, char_count, lower, upper: INTEGER
		do
			if buffer.substring_count > 0 then
				l_area := area; offset := first_index (l_area)
				new_count := count + buffer.substring_count
				if not_empty and then adjacent (last_upper, buffer.first_lower) then
					merge_first := True
					new_count := new_count - 1
				end
				l_area := new_area (new_count, character_count + buffer.character_count)
				l_area [0] := new_count.to_character_32
				-- copy indices
				l_area.copy_data (area, 1, 1, count * 2)
				buffer_area := buffer.area; i_final := buffer_area.count
				from i := 1 until i = i_final loop
					lower := lower_bound (buffer_area, i); upper := upper_bound (buffer_area, i)
					if merge_first implies i > 1 then
						l_area.extend (lower.to_character_32)
						l_area.extend (upper.to_character_32)
					end
					i := i + upper - lower + 3
				end
				if merge_first then
					put_upper (l_area, offset - 2, buffer.first_upper)
				end
				-- copy characters
				l_area.copy_data (area, offset, l_area.count, character_count)
				from i := 1 until i = i_final loop
					lower := lower_bound (buffer_area, i); upper := upper_bound (buffer_area, i)
					char_count := upper - lower + 1
					l_area.copy_data (buffer_area, i + 2, l_area.count, char_count)
					i := i + char_count + 2
				end
				area := l_area
			end
		ensure
			appended: same_string (old joined (Current, buffer.to_substring_array))
		end

	append_list (list: EL_SUBSTRING_32_LIST)
		require
			appendable: list.substring_count > 0 implies last_upper < list.first_lower
		local
			offset, new_count: INTEGER; l_area: like area; merge_first: BOOLEAN
		do
			if list.substring_count > 0 then
				l_area := area; offset := first_index (l_area)
				new_count := count + list.substring_count
				if not_empty and then adjacent (last_upper, list.first_lower) then
					merge_first := True
					new_count := new_count - 1
				end
				l_area := new_area (new_count, character_count + list.character_area.count)
				l_area [0] := new_count.to_character_32
				-- copy indices
				l_area.copy_data (area, 1, 1, count * 2)
				if merge_first then
					l_area.copy_data (list.area, 2, offset, list.count - 2)
					put_upper (l_area, offset - 2, list.first_upper)
				else
					l_area.copy_data (list.area, 0, offset, list.count)
				end
				-- copy characters
				l_area.copy_data (area, offset, l_area.count, character_count)
				l_area.copy_data (list.character_area, 0, l_area.count, list.character_area.count)
				area := l_area
			end
		end

	append (other: EL_SUBSTRING_32_ARRAY)
		require
			other_not_empty: other.not_empty
			already_shifted: other.first_lower > last_upper
		local
			i_final, o_final, j_final, delta: INTEGER
			l_area, o_area, joined_area: like area
		do
			if not_empty then
				l_area := area; i_final := first_index (l_area)
				o_area := other.area; o_final := first_index (o_area)
				if adjacent (last_upper, other.first_lower) then
					-- merge adjoining intervals by subtracting `delta' bytes
					delta := 2
				end
				j_final := count * 2 + other.count * 2 - delta + 1
				joined_area := new_joined_area (l_area, o_area, delta)
				-- copy `count' + intervals
				joined_area.copy_data (l_area, 1, 1, i_final - 1)

				-- copy other intervals without `count'
				joined_area.copy_data (o_area, 1 + delta, i_final, o_final - delta - 1)
				-- copy substrings
				joined_area.copy_data (l_area, i_final, j_final, character_count)
				-- copy other substrings
				joined_area.copy_data (o_area, o_final, joined_area.count, other.character_count)
				if delta = 2 then
					put_upper (joined_area, i_final - 2, other.first_upper)
				end
				area := joined_area
			else
				area := other.area.twin
			end
		ensure
			valid_character_count: character_count = old character_count + other.character_count
			valid_merge_count: old (not_empty and then adjacent (last_upper, other.first_lower)) implies count = old count + other.count - 1
			valid_count: old (not_empty and then last_upper + 1 < other.first_lower) implies count = old count + other.count
			valid_array: is_valid
		end

	insert (other: EL_SUBSTRING_32_ARRAY)
		require
			no_overlap: not interval_sequence.overlaps (other.interval_sequence)
		local
			it_lead, it_middle: EL_SUBSTRING_32_ARRAY_ITERATOR; l_area: like area;
			offset, lead_count, middle_count, trailing_count, src_index, dest_index: INTEGER
		do
			if other.count = 0 then
				do_nothing

			elseif count = 0 then
				make_from_other (other)
			else
				create l_area.make_empty (area.count + other.area.count - 1)
				l_area.extend ('%U')
				if first_upper < other.first_lower then
					it_lead := start (Current); it_middle := start (other)
				else
					it_lead := start (other); it_middle := start (Current)
				end
				from until it_lead.after or else it_middle < it_lead loop
					extend_interval (l_area, it_lead.lower, it_lead.upper)
					lead_count := lead_count + it_lead.character_count
					it_lead.forth
				end
				from until it_middle.after loop
					extend_interval (l_area, it_middle.lower, it_middle.upper)
					middle_count := middle_count + it_middle.character_count
					it_middle.forth
				end
				if not it_lead.after then
					from until it_lead.after loop
						extend_interval (l_area, it_lead.lower, it_lead.upper)
						trailing_count := trailing_count + it_lead.character_count
						it_lead.forth
					end
				end
				offset := value (l_area, 0) * 2 + 1
				l_area.copy_data (it_lead.area, it_lead.offset, offset, lead_count)
				l_area.copy_data (it_middle.area, it_middle.offset, offset + lead_count, middle_count)
				if trailing_count.to_boolean then
					src_index := it_lead.offset + lead_count
					dest_index := offset + lead_count + middle_count
					l_area.copy_data (it_lead.area, src_index, dest_index, trailing_count)
				end
				area := l_area
			end
		ensure
			valid_array: is_valid
		end

	put (uc: CHARACTER_32; index: INTEGER)
		local
			i, lower, upper, i_final, offset: INTEGER
			found: BOOLEAN; l_area: like area
		do
			l_area := area; i_final := first_index (l_area); offset := i_final
			-- search for existing substring to update
			from i := 1 until found or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= index and then index <= upper then
					-- update interval
					l_area.put (uc, offset + index - lower)
					found := True
				end
				offset := offset + upper - lower + 1
				i := i + 2
			end
			if not found then
				insert (character_substring (uc, index))
			end
		ensure
			code_set: item (index) = uc
		end

	prepend (other: EL_SUBSTRING_32_ARRAY)
		require
			already_shifted: (not_empty and other.not_empty) implies other.last_upper < first_lower
		local
			i_final, o_final, j_final, delta: INTEGER
			l_area, o_area, joined_area: like area
		do
			if count = 0 then
				area := other.area.twin

			elseif other.not_empty then
				l_area := area; i_final := first_index (l_area)
				o_area := other.area; o_final := first_index (o_area)
				if adjacent (other.last_upper, first_lower) then
					-- merge adjoining intervals by subtracting `delta' bytes
					delta := 2
				end
				j_final := count * 2 + other.count * 2 - delta + 1
				joined_area := new_joined_area (l_area, o_area, delta)

				-- copy other intervals with `other.count'
				joined_area.copy_data (o_area, 1, 1, o_final - 1)

				-- copy intervals without `count'
				joined_area.copy_data (l_area, 1 + delta, o_final, i_final - delta - 1)
				-- copy other substrings
				joined_area.copy_data (o_area, o_final, j_final, other.character_count)
				-- copy substrings
				joined_area.copy_data (l_area, i_final, joined_area.count, character_count)
				if delta = 2 then
					put_upper (joined_area, o_final - 2, first_upper)
				end
				area := joined_area
			end
		ensure
			valid_character_count: character_count = old character_count + other.character_count
			valid_merge_count: old (not_empty and then adjacent (other.last_upper, first_lower)) implies count = old count + other.count - 1
			valid_count: old (not_empty and then other.last_upper + 1 < first_lower) implies count = old count + other.count
			valid_array: is_valid
		end

	remove (index: INTEGER)
		local
			i, lower, upper, char_count, i_final, offset: INTEGER
			l_area, l_new_area: like area; found: BOOLEAN
		do
			l_area := area; i_final := first_index (l_area); offset := i_final
			from i := 1 until found or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= index and index <= upper then
					if lower = upper then
					-- remove entire substring
						l_new_area := new_area (count - 1, character_count - 1)
					elseif index = lower then
					-- remove first character substring
						l_new_area := new_area (count, character_count - 1)
					elseif index = upper then
					-- remove last character substring
						l_new_area := new_area (count, character_count - 1)
					else
					-- Split substring into two
						l_new_area := new_area (count + 1, character_count - 1)
					end
					found := True
				end
				i := i + 2
			end
			if found then
				-- Copy indexing data
				from i := 1 until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					if lower <= index and index <= upper then
						if lower = upper then
						-- remove entire substring
						elseif index = lower then
						-- remove first character substring
							extend_interval (l_new_area, lower + 1, upper)
						elseif index = upper then
						-- remove last character substring
							extend_interval (l_new_area, lower, upper - 1)
						else
						-- Split substring into two
							extend_interval (l_new_area, lower, index - 1)
							extend_interval (l_new_area, index + 1, upper)
						end
					else
						extend_interval (l_new_area, lower, upper)
					end
					i := i + 2
				end
				-- Copy character data
				from i := 1 until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					char_count := upper - lower + 1
					if lower <= index and index <= upper then
						if lower = upper then
						-- remove entire substring
						elseif index = lower then
						-- remove first character substring
							l_new_area.copy_data (l_area, offset + 1, l_new_area.count, char_count - 1)
						elseif index = upper then
						-- remove last character substring
							l_new_area.copy_data (l_area, offset, l_new_area.count, char_count - 1)
						else
						-- Split substring into two
							l_new_area.copy_data (l_area, offset, l_new_area.count, index - lower)
							l_new_area.copy_data (l_area, offset + index - lower + 1, l_new_area.count, upper - index)
						end
					else
						l_new_area.copy_data (l_area, offset, l_new_area.count, char_count)
					end
					offset := offset + char_count
					i := i + 2
				end
				area := l_new_area
			end
		ensure
			valid_array: is_valid
		end

	remove_substring (start_index, end_index: INTEGER)
		local
			i, lower, upper, new_char_count, i_final, offset, new_offset, new_count: INTEGER
			old_lower, old_upper, delta, shift_count, crop_count: INTEGER
			l_area, l_new_area, index_area: like area
		do
			shift_count := end_index - start_index + 1
			l_area := area; i_final := first_index (l_area)
			offset := i_final
			index_area := new_area (count, 0)
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if upper < start_index then
					-- Unchanged
					extend_interval (index_area, lower, upper)

				elseif start_index <= lower and upper <= end_index then
					-- Remove entire section
					upper := lower - 1

				elseif lower <= start_index and end_index <= upper then
					-- Remove middle section
					upper := upper - shift_count
					extend_interval (index_area, lower, upper)

				elseif lower <= end_index and end_index <= upper then
					-- Remove leading section
					lower := end_index + 1
					extend_interval (index_area, lower - shift_count, upper - shift_count)

				elseif lower <= start_index and start_index <= upper then
					-- Remove trailing section
					upper := start_index - 1
					extend_interval (index_area, lower, upper)

				elseif end_index < lower then
					-- Left shifted
					extend_interval (index_area, lower - shift_count, upper - shift_count)
				end
				new_char_count := new_char_count + upper - lower + 1
				i := i + 2
			end
			new_count := value (index_area, 0)

			crop_count := character_count - new_char_count
			if crop_count.to_boolean or count /= new_count then
				l_new_area := new_area (new_count, new_char_count)
				new_offset := index_area.count
				l_new_area.copy_data (index_area, 0, 0, index_area.count)
				-- copy character data
				from i := 1 until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					old_lower := lower; old_upper := upper
					if upper < start_index then
						-- Unchanged
						l_new_area.copy_data (l_area, offset, new_offset, upper - lower + 1)

					elseif start_index <= lower and upper <= end_index then
						-- Remove entire section
						upper := lower - 1

					elseif lower <= start_index and end_index <= upper then
						-- Remove middle section
						delta := end_index - lower + 1
						l_new_area.copy_data (l_area, offset, new_offset, start_index - lower)
						l_new_area.copy_data (l_area, offset + delta, new_offset + start_index - lower, upper - end_index)
						upper := upper - shift_count

					elseif lower <= end_index and end_index <= upper then
						-- Remove leading section
						lower := end_index + 1; delta := lower - old_lower
						l_new_area.copy_data (l_area, offset + delta, new_offset, upper - lower + 1)

					elseif lower <= start_index and start_index <= upper then
						-- Remove trailing section
						upper := start_index - 1
						l_new_area.copy_data (l_area, offset, new_offset, upper - lower + 1)

					elseif end_index < lower then
						-- Left shifted
						l_new_area.copy_data (l_area, offset, new_offset, upper - lower + 1)
					end
					new_offset := new_offset + upper - lower + 1
					offset := offset + old_upper - old_lower + 1
					i := i + 2
				end
				area := l_new_area
			else
				area.copy_data (index_area, 0, 0, index_area.count)
			end
		ensure
			valid_array: is_valid
		end

	set_area (a_area: like area)
		do
			area := a_area
		ensure
			valid_array: is_valid
		end

	set_from_buffer (buffer: EL_SUBSTRING_32_BUFFER)
		do
			if buffer.is_empty then
				area := Empty_area
			else
				set_area (buffer.to_substring_area)
			end
		end

feature -- Basic operations

	append_substrings_into (buffer: EL_SUBSTRING_32_BUFFER; start_index, end_index: INTEGER)
		local
			i, lower, upper, offset, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := first_index (l_area); offset := i_final
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= start_index and then end_index <= upper then
				-- Append contained substring
					buffer.append_interval (l_area, start_index, end_index, offset + (start_index - lower))

				elseif start_index <= lower and then upper <= end_index then
				-- Append full substring
					buffer.append_interval (l_area, lower, upper, offset)

				elseif lower <= end_index and then end_index <= upper then
				-- Append left section
					buffer.append_interval (l_area, lower, end_index, offset)

				elseif lower <= start_index and then start_index <= upper then
				-- Append right section
					buffer.append_interval (l_area, start_index, upper, offset + (start_index - lower))
				end
				offset := offset + upper - lower + 1
				i := i + 2
			end
		end

	write (area_out: SPECIAL [CHARACTER_32]; a_offset: INTEGER)
			-- write substrings into expanded string 'str'
		require
			string_big_enough: last_upper + a_offset <= area_out.count
		local
			i, j, lower, upper, char_count, i_final, offset: INTEGER; l_area: like area
		do
			l_area := area; i_final := first_index (l_area)
			offset := i_final
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				from j := 0 until j = char_count loop
					area_out [a_offset + j + lower - 1] := l_area.item (offset + j).to_character_32
					j := j + 1
				end
				offset := offset + char_count
				i := i + 2
			end
		end

feature -- Duplication

	shifted (n: INTEGER): EL_SUBSTRING_32_ARRAY
		do
			create Result.make_from_other (Current)
			Result.shift (n)
		end

feature -- Contract Support

	is_valid: BOOLEAN
		-- `True' if all substrings are sequential and separated by at least one character
		local
			i, i_final: INTEGER; l_area: like area
		do
			Result := True
			if count > 1 then
				l_area := area; i_final := first_index (l_area)
				from i := 3 until not Result or else i = i_final loop
					Result := upper_bound (l_area, i - 2) + 1 < lower_bound (l_area, i)
					i := i + 2
				end
			end
		end

	interval_sequence: EL_SEQUENTIAL_INTERVALS
		local
			i, i_final: INTEGER; l_area: like area
		do
			create Result.make (count)
			l_area := area; i_final := first_index (l_area)
			from i := 1 until i = i_final loop
				Result.extend (lower_bound (l_area, i), upper_bound (l_area, i))
				i := i + 2
			end
		ensure
			full: Result.full
			same_first_lower: first_lower = Result.first_lower
			same_last_upper: last_upper = Result.last_upper
		end

	joined (a, b: EL_SUBSTRING_32_ARRAY): EL_SUBSTRING_32_ARRAY
		do
			create Result.make_from_other (a)
			Result.append (b)
		end

	overlaps (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := not (end_index < first_lower) and then not (start_index > last_upper)
		end

end