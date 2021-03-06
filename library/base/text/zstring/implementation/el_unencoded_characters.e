note
	description: "[
		Representation of consecutive substrings in a [$source STRING_32] string that could not be encoded using
		a latin character set. The substring are held in the array 
		
			area: [$source SPECIAL [NATURAL]]
			
		Each substring is prececded by two 32 bit characters representing the lower and upper index.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:54:25 GMT (Tuesday 2nd March 2021)"
	revision: "28"

class
	EL_UNENCODED_CHARACTERS

inherit
	EL_UNENCODED_CHARACTERS_IMPLEMENTATION
		export
			{EL_ZCODE_CONVERSION} lower_bound, upper_bound, is_valid, substring_list, Buffer
		end

	EL_ZCODE_CONVERSION

create
	make, make_from_other, make_joined

feature {NONE} -- Initialization

	make
		do
			area := Empty_unencoded
		end

	make_filled (uc: CHARACTER_32; n: INTEGER)
		do
			create area.make_filled (uc.natural_32_code, n + 2)
			area.put (1, 0)
			area.put (n.to_natural_32, 1)
		end

	make_joined (a, b: EL_UNENCODED_CHARACTERS; offset: INTEGER)
		-- make `a' joined with `b' shifted `offset' places to right
		local
			i, lower, upper, i_final: INTEGER; l_area, area_a, area_b, current_area: like area
		do
			l_area := area; current_area := l_area
			area_a := a.area; area_b := b.area
			if area_a.count > 0 and area_b.count > 0 then
				i := a.last_index
				upper := upper_bound (area_a, i)
				if upper + 1 = b.first_lower + offset then
					-- merge intervals
					l_area := area_a.aliased_resized_area (area_a.count + area_b.count - 2)
					l_area.copy_data (area_b, 2, area_a.count, area_b.count - 2)
					upper := b.first_upper + offset
					put_upper (l_area, i, upper)
					i := i + upper - lower_bound (l_area, i) + 3
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
				i_final := l_area.count
				from until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					put_lower (l_area, i, lower + offset)
					put_upper (l_area, i, upper + offset)
					i := i + upper - lower + 3
				end
			end
			set_if_changed (current_area, l_area)
		ensure
			valid_count: character_count = old (a.character_count + b.character_count)
		end

	make_from_other (other: EL_UNENCODED_CHARACTERS)
		do
			if other.not_empty then
				area := other.area.twin
			else
				make
			end
		end

feature -- Access

	code (index: INTEGER): NATURAL
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until Result > 0 or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= index and then index <= upper then
					Result := l_area [i + index - lower + 2]
				end
				i := i + upper - lower + 3
			end
		end

	count_greater_than_zero_flags (other: EL_UNENCODED_CHARACTERS): INTEGER
		do
			Result := ((area.count > 0).to_integer |<< 1) | (other.area.count > 0).to_integer
		end

	first_lower: INTEGER
		local
			l_area: like area
		do
			l_area := area
			if l_area.count > 0 then
				Result := l_area.item (0).to_integer_32
			end
		end

	first_upper: INTEGER
		local
			l_area: like area
		do
			l_area := area
			if l_area.count > 0 then
				Result := l_area.item (1).to_integer_32
			end
		end

	hash_code (seed: INTEGER): INTEGER
			-- Hash code value
		local
			i, offset, lower, upper, count, i_final: INTEGER; l_area: like area
		do
			Result := seed
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				from i := i + 2; offset := 0 until offset = count loop
					-- The magic number `8388593' below is the greatest prime lower than
					-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
					Result := ((Result \\ 8388593) |<< 8) + l_area.item (i + offset).to_integer_32
					offset := offset + 1
				end
				i := i + count
			end
		end

	index_of (unicode: NATURAL; start_index: INTEGER): INTEGER
		local
			i, j, lower, upper, count, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until Result > 0 or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if start_index <= lower or else start_index <= upper then
					from j := lower.max (start_index) - lower + 1 until Result > 0 or else j > count loop
						if l_area [i + 1 + j] = unicode then
							Result := lower + j - 1
						end
						j := j + 1
					end
				end
				i := i + count + 2
			end
		end

	interval_sequence: EL_SEQUENTIAL_INTERVALS
		local
			i, lower, upper, count, i_final: INTEGER; l_area: like area
		do
			create Result.make (3)
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				Result.extend (lower, upper)
				i := i + count + 2
			end
		end

	item (index: INTEGER): CHARACTER_32
		require
			valid_index: index >= 1
		do
			Result := code (index).to_character_32
		end

	last_index: INTEGER
			-- index into `area' of last interval
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				i := i + upper - lower + 3
			end
			if lower.to_boolean then
				Result := i - (upper - lower + 3)
			end
		end

	last_index_of (unicode: NATURAL; start_index_from_end: INTEGER): INTEGER
		local
			i, j, k, lower, upper, count: INTEGER; l_area: like area
			list: like index_list; index_area: SPECIAL [INTEGER]
		do
			l_area := area; list := index_list; index_area := list.area
			from k := list.count - 1 until Result > 0 or else k < 0 loop
				i := index_area [k]
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if upper <= start_index_from_end or else lower <= start_index_from_end then
					from j := upper.min (start_index_from_end) - lower + 1 until Result > 0 or else j = 0 loop
						if l_area [i + 1 + j] = unicode then
							Result := lower + j - 1
						end
						j := j - 1
					end
				end
				k := k - 1
			end
		end

	last_upper: INTEGER
			-- count when substrings are expanded to original source string
		local
			l_area: like area
		do
			l_area := area
			if l_area.count >= 2 then
				Result := upper_bound (l_area, last_index)
			end
		end

	z_code (index: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (code (index))
		end

feature -- Measurement

	substring_count: INTEGER
		-- count of substrings
		local
			i, lower, upper, count, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				Result := Result + 1
				i := i + count + 2
			end
		end

	occurrences (unicode: NATURAL): INTEGER
		local
			i, j, lower, upper, count, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				from j := 1 until j > count loop
					if l_area [i + 1 + j] = unicode then
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
			i, lower, upper, count, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				Result := Result + count
				i := i + count + 2
			end
		end

	intersection_count (start_index, end_index: INTEGER): INTEGER
		-- count of characters between `start_index'and `end_index'
		local
			i, lower, upper, max_count, i_final: INTEGER
			l_area: like area
		do
			l_area := area; i_final := l_area.count
			max_count := end_index - start_index + 1
			from i := 0 until Result = max_count or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				if lower <= start_index and end_index <= upper then
					-- Remove middle section
					Result := max_count
				elseif start_index <= lower and upper <= end_index then
					-- Remove entire section
					Result := Result + upper - lower + 1
				elseif lower <= end_index and end_index <= upper then
					-- Remove leading section
					Result := Result + end_index - lower + 1

				elseif lower <= start_index and start_index <= upper then
					-- Remove trailing section
					Result := Result + upper - start_index + 1
				end
				i := i + upper - lower + 3
			end
		end

	utf_8_byte_count: INTEGER
		local
			i, j, lower, upper, count, i_final: INTEGER; l_area: like area
			l_code: NATURAL_32
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				from j := 1 until j > count loop
					l_code := l_area [i + 1 + j]
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
					j := j + 1
				end
				i := i + count + 2
			end
		end

feature -- Status query

	has (unicode: NATURAL): BOOLEAN
		do
			Result := index_of (unicode, 1) > 0
		end

	intersects (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if some characters are between `start_index' and `end_index'
		local
			i, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			if i_final.to_boolean and then end_index >= lower_bound (l_area, i) then
				from i := 0 until Result or else i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					if start_index <= lower and then lower <= end_index then
						Result := True

					elseif start_index <= upper and then upper <= end_index then
						Result := True
					end
					i := i + upper - lower + 3
				end
			end
		end

	overlaps (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := not (end_index < first_lower) and then not (start_index > last_upper)
		end

feature -- Comparison

	same_string (other: EL_UNENCODED_CHARACTERS): BOOLEAN
		local
			l_area: like area
		do
			l_area := area
			if l_area.count = other.area.count then
				Result := l_area.same_items (other.area, 0, 0, l_area.count)
			end
		end

feature -- Element change

	append (other: EL_UNENCODED_CHARACTERS; offset: INTEGER)
		local
			i, lower, upper, i_final: INTEGER; l_area, current_area, o_area: like area
		do
			l_area := area; current_area := l_area; o_area := other.area
			if l_area.count > 0 and o_area.count > 0 then
				i := last_index
				upper := upper_bound (l_area, i)
				if upper + 1 = other.first_lower + offset then
					-- merge intervals
					l_area := big_enough (l_area, o_area.count - 2)
					l_area.copy_data (o_area, 2, l_area.count, o_area.count - 2)
					upper := other.first_upper + offset
					put_upper (l_area, i, upper)
					i := i + upper - lower_bound (l_area, i) + 3
				else
					i := l_area.count
					l_area := big_enough (l_area, o_area.count)
					l_area.copy_data (o_area, 0, l_area.count, o_area.count)
				end

			elseif o_area.count > 0 then
				l_area := o_area.twin
			end
			if offset.abs.to_boolean and then l_area.count > 0 then
				-- Shift offset places to right
				i_final := l_area.count
				from until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					put_lower (l_area, i, lower + offset)
					put_upper (l_area, i, upper + offset)
					i := i + upper - lower + 3
				end
			end
			set_if_changed (current_area, l_area)
		ensure
			valid_count: character_count = old character_count + other.character_count
		end

	insert (other: EL_UNENCODED_CHARACTERS)
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
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if not other_inserted and then previous_upper < other_lower and then other_last_upper < lower then
					-- Insert other
					l_area := big_enough (area, other_array_count)
					l_area.insert_data (other_unencoded, 0, i, other_array_count)
					i_final := i_final + other_array_count
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					count := upper - lower + 1
					other_inserted := True
				end
				if other_inserted and then previous_upper > 0 and then previous_upper + 1 = lower then
					-- Merge intervals that are continous with previous
					l_area.overlapping_move (i + 2, i, l_area.count - i - 2)
					l_area.remove_tail (2)
					i := previous_i; upper := previous_upper + count
					lower := lower_bound (l_area, i)
					l_area.put (upper.to_natural_32, i + 1)
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

	interval_index: EL_UNENCODED_CHARACTERS_INDEX
		do
			Result := Once_interval_index_1
			Result.set_area (area)
		end

	interval_index_other: EL_UNENCODED_CHARACTERS_INDEX
		do
			Result := Once_interval_index_2
			Result.set_area (area)
		end

	put_code (a_code: NATURAL; index: INTEGER)
		local
			i, previous_i, previous_upper, lower, upper, count, i_final: INTEGER; found: BOOLEAN
			l_area, current_area: like area
		do
			l_area := area; current_area := l_area; i_final := l_area.count
			from i := 0 until found or i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if lower <= index and then index <= upper then
					-- update interval
					l_area.put (a_code, i + 2 + index - lower)
					found := True
				elseif upper + 1 = index then
					-- extend interval right
					count := count + 1
					l_area := extended_enough (l_area, i + count + 1, 0, 0, a_code)
					l_area.put (index.to_natural_32, i + 1)
					found := True
				elseif lower - 1 = index then
					-- extend interval left
					count := count + 1
					lower := lower - 1
					l_area := extended_enough (l_area, i + 2, 0, 0, a_code)
					l_area.put (index.to_natural_32, i)
					found := True

				elseif previous_upper < index and then index < lower then
					-- insert a new interval
					l_area := extended_enough (l_area, previous_i, index, index, a_code)
					i := i + 3
					found := True
				end
				if previous_upper > 0 and then previous_upper + 1 = lower then
					-- Merge interval with previous
					l_area.overlapping_move (i + 2, i, l_area.count - i - 2)
					l_area.remove_tail (2)
					i := previous_i; upper := previous_upper + count
					lower := lower_bound (l_area, i)
					l_area.put (upper.to_natural_32, i + 1)
					count := upper - lower + 1
					i_final := i_final - 2
				end
				previous_upper := upper; previous_i := i
				i := i + count + 2
			end
			if not found then
				-- append a new interval
				l_area := extended_enough (l_area, l_area.count, index, index, a_code)
			end
			set_if_changed (current_area, l_area)
		ensure
			code_set: code (index) = a_code
		end

	set_from_buffer (a_area: EL_UNENCODED_CHARACTERS_BUFFER)
		do
			if a_area.not_empty then
				area := a_area.area_copy
			else
				area := Empty_unencoded
			end
		ensure
			is_valid: is_valid
		end

	shift (offset: INTEGER)
		-- shift intervals right by `offset' characters. `offset' < 0 shifts to the left.
		do
			shift_from (1, offset)
		end

	shift_from (index, offset: INTEGER)
		-- shift intervals right by `offset' characters starting from `index'.
		-- Split if interval has `index' and `index' > `lower'
		-- `offset < 0' shifts to the left.
		local
			i, lower, upper, count, i_final: INTEGER; l_area, current_area: like area
		do
			if offset /= 0 then
				l_area := area; current_area := l_area; i_final := l_area.count
				from i := 0 until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					count := upper - lower + 1
					if index <= lower then
						put_lower (l_area, i, lower + offset)
						put_upper (l_area, i, upper + offset)
					elseif lower < index and then index <= upper then
						-- Split the interval in two
						put_upper (l_area, i, index - 1)
						l_area := extended_enough (l_area, i + 2 + index - lower, index + offset, upper + offset, 0)
						i_final := i_final + 2
						i := i + 2
					end
					i := i + count + 2
				end
				set_if_changed (current_area, l_area)
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

	replace_character (uc_old, uc_new: NATURAL; shift_remaining: BOOLEAN)
		-- replace all `uc_old' with `uc_new' and shifting to left if `shift_remaining = True'
		-- if `uc_new = 0' then remove `uc_old'
		local
			i, j, lower, upper, count, i_final, previous_i, delta: INTEGER
			l_area: like area; found: BOOLEAN; l_buffer: like empty_buffer
			l_code: NATURAL
		do
			previous_i := (1).opposite
			l_area := area; i_final := l_area.count
			from i := 0 until found or else i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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
			if found then
				l_buffer := empty_buffer
				if previous_i >= 0 then
					l_buffer.append_from_area (l_area, previous_i)
				end
				from until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					from j := lower until j > upper loop
						l_code := l_area [i + 2 + j - lower]
						if l_code = uc_old then
							if uc_new > 0 then
								l_buffer.extend (uc_new, j)
							elseif shift_remaining then
								delta := delta + 1
							end
						else
							l_buffer.extend (l_code, j - delta)
						end
						j := j + 1
					end
					i := i + upper - lower + 3
				end
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
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
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
							l_area.put ((lower + 1).to_natural_32, i)
						else
							l_area.put ((upper - 1).to_natural_32, i + 1)
						end
					end
					found := True
				elseif lower < index and index < upper then
					-- Split interval in two
					destination_index := i + 2 + index - lower
					l_area := extended_enough (l_area, destination_index, index + 1, 0, 0)
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
			i, j, i_final, pruned_count, lower, upper: INTEGER
			l_area: like area; l_buffer: like empty_buffer
		do
			l_area := area; i_final := area.count
			if not list.is_empty and then i_final > 0 then
				l_buffer := empty_buffer
				from i := 0; list.start until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					from until list.after or else list.item >= lower loop
						list.forth
						pruned_count := pruned_count + 1
					end
					from j := lower until j > upper loop
						if not list.after and then list.item = j then
							pruned_count := pruned_count + 1
							list.forth
						else
							l_buffer.extend (l_area [i + 2 + j - lower], j - pruned_count)
						end
						j := j + 1
					end
					i := i + upper - lower + 3
				end
				set_from_buffer (l_buffer)
			end
		end

	remove_substring (start_index, end_index: INTEGER)
		local
			i, lower, upper, count, i_final, removed_count, deleted_count, previous_i, previous_upper: INTEGER
			l_area: like area
		do
			l_area := area; i_final := l_area.count
			deleted_count := end_index - start_index + 1
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				removed_count := 0
				if lower <= start_index and end_index <= upper then
					-- Remove middle section
					removed_count := remove_section (l_area, i, lower, upper, start_index, end_index, deleted_count)
				elseif start_index <= lower and upper <= end_index then
					-- Remove entire section
					removed_count := remove_section (l_area, i, lower, upper, lower, upper, deleted_count)
				elseif lower <= end_index and end_index <= upper then
					-- Remove leading section
					removed_count := remove_section (l_area, i, lower, upper, lower, end_index, deleted_count)

				elseif lower <= start_index and start_index <= upper then
					-- Remove trailing section
					removed_count := remove_section (l_area, i, lower, upper, start_index, upper, deleted_count)

				elseif lower > end_index then
					l_area [i] := (lower - deleted_count).to_natural_32
					l_area [i + 1] := (upper - deleted_count).to_natural_32
				end
				if removed_count > 0 then
					if removed_count = count + 2 then
						-- Section removed
						i_final := i_final - removed_count
						if i_final = 0 then
							area := Empty_unencoded
						end
					else
						lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
						if previous_upper > 0 and then previous_upper + 1 = lower then
							-- Merge interval with previous
							l_area.overlapping_move (i + 2, i, l_area.count - i - 2)
							l_area.remove_tail (2)
							i := previous_i
							lower := lower_bound (l_area, i)
							l_area.put (upper.to_natural_32, i + 1)
							count := upper - lower + 1
							i_final := i_final - removed_count - 2
							removed_count := 0
						else
							i_final := i_final - removed_count
						end
					end
				end
				previous_i := i; previous_upper := upper
				i := i + count + 2 - removed_count
			end
		end

feature -- Basic operations

	write (area_out: SPECIAL [CHARACTER_32]; offset: INTEGER)
			-- write substrings into expanded string 'str'
		require
			string_big_enough: last_upper + offset <= area_out.count
		local
			i, j, lower, upper, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				from j := lower until j > upper loop
					area_out [offset + j - 1] := l_area.item (i + 2 + j - lower).to_character_32
					j := j + 1
				end
				i := i + upper - lower + 3
			end
		end

feature -- Duplication

	shifted (offset: INTEGER): EL_UNENCODED_CHARACTERS
		do
			create Result.make_from_other (Current)
			Result.shift (offset)
		end

end