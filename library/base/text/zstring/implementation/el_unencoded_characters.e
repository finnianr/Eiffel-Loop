note
	description: "[
		Representation of consecutive substrings in a `STRING_32' string that could not be encoded using
		a latin character set. The substring are held in the array 
		
			area: SPECIAL [NATURAL]
			
		Each substring is prececded by two 32 bit characters representing the lower and upper index.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-24 17:26:19 GMT (Sunday 24th January 2021)"
	revision: "18"

class
	EL_UNENCODED_CHARACTERS

inherit
	EL_ZCODE_CONVERSION

create
	make, make_from_other

feature {NONE} -- Initialization

	make
		do
			area := Empty_unencoded
		end

	make_filled (uc: CHARACTER_32; n: INTEGER)
		do
			create area.make_filled (uc.natural_32_code, n + 2)
			area [0] := 1
			area [1] := n.to_natural_32
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
			i, lower, upper, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until Result > 0 or else i = area_count loop
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
			i, offset, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			Result := seed
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
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
			i, j, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until Result > 0 or else i = area_count loop
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
			i, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			create Result.make (3)
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
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

	last_index_of (unicode: NATURAL; start_index_from_end: INTEGER): INTEGER
		local
			i, j, lower, upper, count, area_count: INTEGER; l_area: like area
			l_index_list: like index_list
		do
			l_area := area; area_count := l_area.count
			l_index_list := index_list
			from l_index_list.finish until Result > 0 or else l_index_list.before loop
				i := l_index_list.item
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
				l_index_list.back
			end
		end

	last_upper: INTEGER
			-- count when substrings are expanded to original source string
		local
			i, lower, upper, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				i := i + upper - lower + 3
			end
			Result := upper
		end

	z_code (index: INTEGER): NATURAL
		do
			Result := unicode_to_z_code (code (index))
		end

feature -- Measurement

	substring_count: INTEGER
		-- count of substrings
		local
			i, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				Result := Result + 1
				i := i + count + 2
			end
		end

	occurrences (unicode: NATURAL): INTEGER
		local
			i, j, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
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
			i, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				Result := Result + count
				i := i + count + 2
			end
		end

	utf_8_byte_count: INTEGER
		local
			i, j, lower, upper, count, area_count: INTEGER; l_area: like area
			l_code: NATURAL_32
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
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

feature -- Access attributes

	area: SPECIAL [NATURAL]

feature -- Status query

	has (unicode: NATURAL): BOOLEAN
		do
			Result := index_of (unicode, 1) > 0
		end

	not_empty: BOOLEAN
		do
			Result := area.count > 0
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

	append (other: EL_UNENCODED_CHARACTERS)
		require
			other_not_empty: other.not_empty
			already_shifted: other.first_lower > last_upper
		local
			i, lower, upper, count, area_count: INTEGER; l_area, other_unencoded: like area
		do
			if not_empty then
				other_unencoded := other.area
				l_area := area; area_count := l_area.count
				from i := 0 until i = area_count loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					count := upper - lower + 1
					i := i + count + 2
				end
				if upper + 1 = other.first_lower then
					-- merge intervals
					l_area := resized (l_area, area_count + other_unencoded.count - 2)
					l_area.copy_data (other_unencoded, 2, i, other_unencoded.count - 2)
					l_area.put (other_unencoded [1], i - count - 1)
				else
					l_area := resized (l_area, area_count + other_unencoded.count)
					l_area.copy_data (other_unencoded, 0, i, other_unencoded.count)
				end
			else
				area := other.area.twin
			end
		ensure
			valid_count: character_count = old character_count + other.character_count
		end

	insert (other: EL_UNENCODED_CHARACTERS)
		require
			no_overlap: not interval_sequence.overlaps (other.interval_sequence)
		local
			i, previous_i, lower, upper, previous_upper, count, area_count: INTEGER
			other_lower, other_last_upper, other_array_count: INTEGER
			l_area, other_unencoded: like area; other_inserted: BOOLEAN
		do
			l_area := area; area_count := l_area.count
			other_unencoded := other.area; other_array_count := other_unencoded.count
			other_lower := other.first_lower; other_last_upper := other.last_upper
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if not other_inserted and then previous_upper < other_lower and then other_last_upper < lower then
					-- Insert other
					grow (area_count + other_array_count)
					l_area := area
					l_area.insert_data (other_unencoded, 0, i, other_array_count)
					area_count := area_count + other_array_count
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
					area_count := area_count - 2
				end
				previous_upper := upper
				previous_i := i
				i := i + count + 2
			end
			if not other_inserted then
				append (other)
			end
		end

	interval_index: like Once_interval_index
		do
			Result := Once_interval_index
			Result.set_area (area)
		end

	put_code (a_code: NATURAL; index: INTEGER)
		local
			i, previous_i, previous_upper, lower, upper, count, area_count: INTEGER; found: BOOLEAN
			l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until found or i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if lower <= index and then index <= upper then
					-- update interval
					l_area.put (a_code, i + 2 + index - lower)
					found := True
				elseif upper + 1 = index then
					-- extend interval right
					count := count + 1
					l_area := extended (i + count + 1, 0, 0, a_code)
					l_area.put (index.to_natural_32, i + 1)
					found := True
				elseif lower - 1 = index then
					-- extend interval left
					count := count + 1
					lower := lower - 1
					l_area := extended (i + 2, 0, 0, a_code)
					l_area.put (index.to_natural_32, i)
					found := True

				elseif previous_upper < index and then index < lower then
					-- insert a new interval
					l_area := extended (previous_i, index, index, a_code)
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
					area_count := area_count - 2
				end
				previous_upper := upper; previous_i := i
				i := i + count + 2
			end
			if not found then
				-- append a new interval
				l_area := extended (l_area.count, index, index, a_code)
			end
		ensure
			code_set: code (index) = a_code
		end

	set_area (a_area: like area)
		do
			area := a_area
		ensure
			valid_unencoded: is_unencoded_valid
		end

	set_from_extendible (a_area: EL_EXTENDABLE_UNENCODED_CHARACTERS)
		do
			if a_area.not_empty then
				area := a_area.area_copy
			else
				area := Empty_unencoded
			end
		end

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
			i, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			if n /= 0 then
				l_area := area; area_count := l_area.count
				from i := 0 until i = area_count loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					count := upper - lower + 1
					if index <= lower then
						l_area.put ((lower + n).to_natural_32, i)
						l_area.put ((upper + n).to_natural_32, i + 1)
					elseif lower < index and then index <= upper then
						-- Split the interval in two
						l_area.put ((index - 1).to_natural_32, i + 1)
						l_area := extended (i + 2 + index - lower, index + n, upper + n, 0)
						area_count := area_count + 2
						i := i + 2
					end
					i := i + count + 2
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

	remove (index: INTEGER)
		local
			i, lower, upper, count, area_count, removed_count, source_index, destination_index: INTEGER
			l_area: like area; found: BOOLEAN
		do
			l_area := area; area_count := l_area.count
			from i := 0 until found or else i = area_count loop
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
					l_area := extended (destination_index, index + 1, 0, 0)
					l_area.put (upper.to_natural_32, destination_index + 1)
					l_area.put ((index - 1).to_natural_32, i + 1)
					found := True
				end
				i := i + count + 2
			end
		end

	remove_substring (start_index, end_index: INTEGER)
		local
			i, lower, upper, count, area_count, removed_count, deleted_count, previous_i, previous_upper: INTEGER
			l_area: like area
		do
			l_area := area; area_count := l_area.count
			deleted_count := end_index - start_index + 1
			from i := 0 until i = area_count loop
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
						area_count := area_count - removed_count
						if area_count = 0 then
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
							area_count := area_count - removed_count - 2
							removed_count := 0
						else
							area_count := area_count - removed_count
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
			i, j, lower, upper, count, area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				from j := 1 until j > count loop
					area_out [lower + j - 2 + offset] := l_area.item (i + j + 1).to_character_32
					j := j + 1
				end
				i := i + count + 2
			end
		end

feature -- Duplication

	append_substrings_into (other: EL_UNENCODED_CHARACTERS; start_index, end_index: INTEGER)
		local
			i, lower, upper, count, area_count: INTEGER
			l_area: like area
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				count := upper - lower + 1
				if lower <= start_index and then end_index <= upper then
					-- Append full interval
					other.append_interval (l_area, i + 2 + (start_index - lower), start_index, end_index)

				elseif start_index <= lower and then upper <= end_index then
					-- Append full interval
					other.append_interval (l_area, i + 2, lower, upper)

				elseif lower <= end_index and then end_index <= upper then
					-- Append left section
					other.append_interval (l_area, i + 2, lower, end_index)

				elseif lower <= start_index and then start_index <= upper then
					-- Append right section
					other.append_interval (l_area, i + 2 + (start_index - lower), start_index, upper)
				end
				i := i + count + 2
			end
		end

	shifted (n: INTEGER): EL_UNENCODED_CHARACTERS
		do
			create Result.make_from_other (Current)
			Result.shift (n)
		end

--	substring (start_index, end_index: INTEGER): like empty_once_unencoded
--		do
--			Result := empty_once_unencoded
--			append_substrings_into (Result, start_index, end_index)
--			Result.shift ((start_index - 1).opposite)
--		end

feature {EL_ZCODE_CONVERSION} -- Contract Support

	is_unencoded_valid: BOOLEAN
		do
			Result := True
		end

	substring_list: SPECIAL [STRING_32]
			-- Debugging output
		local
			i, j, lower, upper, count, area_count: INTEGER; l_area: like area
			list: ARRAYED_LIST [STRING_32]; string: STRING_32
		do
			create list.make (10)
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
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

feature {EL_ZCODE_CONVERSION} -- Implementation

	append_interval (a_area: like area; source_index, lower, upper: INTEGER)
		local
			old_count, count: INTEGER; l_area: like area
		do
			l_area := area; old_count := area.count; count := upper - lower + 1
			l_area := resized (l_area, old_count + count + 2)
			l_area.put (lower.to_natural_32, old_count)
			l_area.put (upper.to_natural_32, old_count + 1)
			l_area.copy_data (a_area, source_index, old_count + 2, count)
		ensure
			count_increased_by_count: character_count = old character_count + upper - lower + 1
		end

	lower_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i).to_integer_32
		end

	upper_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i + 1).to_integer_32
		end

feature {NONE} -- Implementation

	change_case (as_lower_case: BOOLEAN)
		local
			i, j, index, lower, upper, count, area_count: INTEGER; l_area: like area
			c, new_c: CHARACTER_32
		do
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
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
			if Result.count + l_insert.count > Result.capacity then
				grow (area.count + l_insert.count)
				Result := area
			end
			Result.insert_data (l_insert, 0, destination_index, l_insert.count)
		end

	empty_once_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS
		do
			Result := Once_extendible_unencoded
			Result.wipe_out
		end

	grow (new_count: INTEGER)
		local
			l_area: like area
		do
			l_area := area
			if new_count > l_area.capacity then
				create area.make_empty (new_count + l_area.capacity // 2)
				area.insert_data (l_area, 0, 0, l_area.count)
			end
		ensure
			big_enough: new_count <= area.capacity
		end

	index_list: ARRAYED_LIST [INTEGER]
		local
			i, lower, upper, area_count: INTEGER; l_area: like area
		do
			Result := Once_index_list
			Result.wipe_out
			l_area := area; area_count := l_area.count
			from i := 0 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				Result.extend (i)
				i := i + upper - lower + 3
			end
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

	resized (old_unencoded: like area; new_count: INTEGER): like area
		local
			i, delta: INTEGER
		do
			Result := old_unencoded
			if new_count > Result.capacity then
				grow (new_count)
				Result := area
			end
			delta := new_count - Result.count
			from i := 1 until i > delta loop
				Result.extend (0)
				i := i + 1
			end
		end

feature {NONE} -- `count_greater_than_zero_flags' values

	Both_have_mixed_encoding: INTEGER = 3

	Only_current: INTEGER = 2

	Only_other: INTEGER = 1

	Neither: INTEGER = 0

feature {EL_ZCODEC} -- Constants

	Once_extendible_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS
		once
			create Result.make
		end

feature {NONE} -- Constants

	Empty_unencoded: SPECIAL [NATURAL]
		once
			create Result.make_empty (0)
		end

	Minimum_capacity: INTEGER = 3

	Once_index_list: ARRAYED_LIST [INTEGER]
		once
			create Result.make (5)
		end

	Once_interval_index: EL_UNENCODED_CHARACTERS_INDEX
		once
			create Result.make_default
		end

	Unencoded_insert: SPECIAL [NATURAL]
		once
			create Result.make_empty (3)
		end

end