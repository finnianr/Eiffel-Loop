note
	description: "[
		Array of sequential substrings from an instance of `STRING_32' compacted into a single `SPECIAL' array:
		
			area: SPECIAL [NATURAL]
			
		`area [0]' contains the substring count: `count'
		
		`area [1] -> area [count * 2]' contains a series of `count' interval specifications `[lower, upper]'
		
		`area [count * 2 + 1] -> area [area.count - 1]' contains the combined substring character data
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 11:49:22 GMT (Sunday 3rd January 2021)"
	revision: "7"

class
	EL_SUBSTRING_32_ARRAY

inherit
	EL_SUBSTRING_32_ARRAY_IMPLEMENTATION

create
	make_from_unencoded, make_empty, make_from_other, make_from_area

feature {NONE} -- Initialization

	make_empty
		do
			area := Empty_unencoded
		end

	make_from_area (a_area: like area)
		require
			area_has_count: a_area.count > 0
		do
			if a_area.item (0).to_boolean then
				area := a_area
			else
				make_empty
			end
		end

	make_from_other (other: EL_SUBSTRING_32_ARRAY)
		do
			if other.not_empty then
				area := other.area.twin
			else
				make_empty
			end
		end

	make_from_unencoded (unencoded: EL_UNENCODED_CHARACTERS)
		local
			i, lower, upper, l_count, char_count, i_final, offset: INTEGER
			l_area: like area
		do
			l_count := unencoded.substring_count
			create area.make_empty (l_count * 2 + unencoded.character_count + 1)
			area.extend (l_count.to_natural_32)

			l_area := unencoded.area; i_final := l_area.count
			from i := 0 until i = i_final loop
				lower := unencoded.lower_bound (l_area, i); upper := unencoded.upper_bound (l_area, i)
				area.extend (lower.to_natural_32); area.extend (upper.to_natural_32);
				char_count := upper - lower + 1
				i := i + char_count + 2
			end
			offset := l_count * 2  + 1 -- substring offset
			from i := 0 until i = i_final loop
				lower := unencoded.lower_bound (l_area, i); upper := unencoded.upper_bound (l_area, i)
				char_count := upper - lower + 1
				area.copy_data (l_area, i + 2, offset, char_count)
				offset := offset + char_count
				i := i + char_count + 2
			end
		end

feature -- Access

	area: SPECIAL [NATURAL]

	code (index: INTEGER): NATURAL
		require
			valid_index: valid_index (index)
		local
			i, lower, upper, i_final, offset: INTEGER; l_area: like area
			found: BOOLEAN
		do
			l_area := area; i_final := count * 2 + 1
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

	count_greater_than_zero_flags (other: EL_SUBSTRING_32_ARRAY): INTEGER
		do
			Result := (count.to_boolean.to_integer |<< 1) | count.to_boolean.to_integer
		end

	first_lower: INTEGER
		require
			not_empty: not_empty
		do
			if count.to_boolean then
				Result := area.item (1).to_integer_32
			end
		end

	first_upper: INTEGER
		require
			not_empty: not_empty
		do
			if count.to_boolean then
				Result := area.item (2).to_integer_32
			end
		end

	hash_code (seed: INTEGER): INTEGER
			-- Hash code value
		local
			i, j, offset, i_final, char_count: INTEGER; l_area: like area
		do
			Result := seed
			l_area := area; i_final := count * 2 + 1
			offset := i_final
			from i := 1 until i = i_final loop
				char_count := interval_count (l_area, i)
				from j := 0 until j = char_count loop
					-- The magic number `8388593' below is the greatest prime lower than
					-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
					Result := ((Result \\ 8388593) |<< 8) + l_area.item (offset + j).to_integer_32
					j := j + 1
				end
				offset := offset + char_count
				i := i + 2
			end
		end

	index_of (unicode: NATURAL; start_index: INTEGER): INTEGER
		local
			i, j, lower, upper, offset, char_count, i_final: INTEGER; l_area: like area
			found: BOOLEAN
		do
			l_area := area; i_final := count * 2 + 1
			offset := i_final
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				if start_index <= lower or else start_index <= upper then
					from j := lower.max (start_index) - lower + 1 until found or else j > char_count loop
						if l_area [offset + j - 1] = unicode then
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
		do
			Result := code (index).to_character_32
		end

	last_index_of (unicode: NATURAL; start_index_from_end: INTEGER): INTEGER
		local
			i, j, lower, upper, offset, char_count, i_final: INTEGER; l_area: like area
			found: BOOLEAN
		do
			l_area := area; i_final := count * 2 + 1
			offset := i_final + character_count
			from i := i_final - 2 until found or else i < 0 loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				offset := offset - char_count
				if upper <= start_index_from_end or else lower <= start_index_from_end then
					from j := upper.min (start_index_from_end) - lower + 1 until found or else j = 0 loop
						if l_area [offset + j - 1] = unicode then
							Result := lower + j - 1
							found := True
						end
						j := j - 1
					end
				end
				i := i - 2
			end
		end

	last_upper: INTEGER
		-- index of last character in last substring
		require
			not_empty: not_empty
		do
			Result := area.item (count * 2).to_integer_32
		end

	sub_array (start_index, end_index: INTEGER): EL_SUBSTRING_32_ARRAY
		local
			i, lower, upper, offset, char_count, l_count, l_character_count, i_final: INTEGER
			array_start_index, array_end_index, l_first_lower, l_last_upper: INTEGER
			l_area, sub_area: like area
		do
			l_area := area; i_final := count * 2 + 1
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
				create sub_area.make_empty (1 + l_count * 2 + l_character_count)
				sub_area.extend (l_count.to_natural_32)
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
			Result := area.item (0).to_integer_32
		end

	occurrences (unicode: NATURAL): INTEGER
		local
			i, j, offset, i_final, char_count: INTEGER; l_area: like area
		do
			l_area := area; i_final := count * 2 + 1
			offset := i_final
			from i := 1 until i = i_final loop
				char_count := interval_count (l_area, i)
				from j := 0 until j = char_count loop
					if l_area [offset + j] = unicode then
						Result := Result + 1
					end
					j := j + 1
				end
				offset := offset + char_count
				i := i + 2
			end
		end

	utf_8_byte_count: INTEGER
		local
			i, j, offset, i_final, char_count: INTEGER; l_area: like area
			l_code: NATURAL
		do
			l_area := area; i_final := count * 2 + 1
			offset := i_final
			from i := 1 until i = i_final loop
				char_count := interval_count (l_area, i)
				from j := 0 until j = char_count loop
					l_code := l_area [offset + j]
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
				offset := offset + char_count
				i := i + 2
			end
		end

feature -- Status query

	has (unicode: NATURAL): BOOLEAN
		do
			Result := index_of (unicode, 1) > 0
		end

	not_empty: BOOLEAN
		do
			Result := count.to_boolean
		end

	valid_index (index: INTEGER): BOOLEAN
		local
			i, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := count * 2 + 1
			from i := 1 until Result or else i = i_final loop
				Result := lower_bound (l_area, i) <= index and then index <= upper_bound (l_area, i)
				i := i + 2
			end
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
			i, lower, upper, char_count, i_final: INTEGER; l_area: like area
		do
			if n /= 0 then
				l_area := area; i_final := count * 2 + 1
				from i := 1 until i = i_final loop
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					char_count := upper - lower + 1
					if index <= lower then
						put_interval (l_area, i, lower + n, upper + n)
					elseif lower < index and then index <= upper then
						-- Split the interval in two
						l_area := new_area (l_area, i + 2, 2) -- insert new interval
						put_upper (l_area, i, index - 1)
						put_interval (l_area, i + 2, index + n, upper + n)
						increment_count (l_area, 1)
						area := l_area
						i_final := i_final + 2
						i := i + 2
					end
					i := i + 2
				end
			end
		end

feature -- Element change

	append (other: EL_SUBSTRING_32_ARRAY)
		require
			other_not_empty: other.not_empty
			already_shifted: other.first_lower > last_upper
		local
			i_final, o_final, j_final, delta: INTEGER
			l_area, o_area, joined_area: like area
		do
			if not_empty then
				l_area := area; i_final := count * 2 + 1
				o_area := other.area; o_final := other.count * 2 + 1
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
		end

	insert (other: EL_SUBSTRING_32_ARRAY)
		require
			no_overlap: not interval_sequence.overlaps (other.interval_sequence)
		local
			i, lower, upper, previous_upper, char_count, leading_char_count, delta_lower, delta_upper: INTEGER
			o_first_lower, o_last_upper, i_final, o_final: INTEGER
			l_area, o_area, joined_area: like area; found: BOOLEAN
		do

			if count = 0 or else last_upper < other.first_lower then
				append (other)

			elseif other.not_empty and then other.last_upper < first_lower then
				prepend (other)

			elseif count > 1 then
				l_area := area; i_final := count * 2 + 1
				o_area := other.area; o_final := other.count * 2 + 1
				o_first_lower := other.first_lower; o_last_upper := other.last_upper
				-- find interval to insert
				from i := 0 until found or else i = i_final loop
					if i > 0 then
						previous_upper := upper_bound (l_area, i - 2)
					end
					lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
					char_count := upper - lower + 1
					if previous_upper < o_first_lower and then o_last_upper < lower then
						found := True
					else
						leading_char_count := leading_char_count + char_count
						i := i + 2
					end
				end
				if found then
					if adjacent (previous_upper, o_first_lower) then
						delta_lower := 2
					end
					if adjacent (o_last_upper, lower) then
						delta_upper := 2
					end
					joined_area := new_joined_area (l_area, o_area, delta_lower + delta_upper)
					-- copy start intervals
					joined_area.copy_data (l_area, 1, 1, i * 2)
					-- copy inserted intervals
					joined_area.copy_data (o_area, 1, i * 2 + 1 + delta_lower, o_area.count * 2 - delta_lower - delta_upper)
				end
			end
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
				l_area := area; i_final := count * 2 + 1
				o_area := other.area; o_final := other.count * 2 + 1
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
		end

feature -- Basic operations

	write (area_out: SPECIAL [CHARACTER_32]; a_offset: INTEGER)
			-- write substrings into expanded string 'str'
		require
			string_big_enough: last_upper + a_offset <= area_out.count
		local
			i, j, lower, upper, char_count, i_final, offset: INTEGER; l_area: like area
		do
			l_area := area; i_final := count * 2 + 1
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

	is_unencoded_valid: BOOLEAN
		do
			Result := True
		end

	interval_sequence: EL_SEQUENTIAL_INTERVALS
		local
			i, i_final: INTEGER; l_area: like area
		do
			create Result.make (count)
			l_area := area; i_final := count * 2 + 1
			from i := 1 until i = i_final loop
				Result.extend (lower_bound (l_area, i), upper_bound (l_area, i))
				i := i + 2
			end
		ensure
			full: Result.full
			same_first_lower: first_lower = Result.first_lower
			same_last_upper: last_upper = Result.last_upper
		end

	overlaps (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := not (end_index < first_lower) and then not (start_index > last_upper)
		end

end