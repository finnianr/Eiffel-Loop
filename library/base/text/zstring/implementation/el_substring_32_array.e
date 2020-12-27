note
	description: "[
		Array of sequential substrings from an instance of `STRING_32'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-27 16:07:54 GMT (Sunday 27th December 2020)"
	revision: "2"

class
	EL_SUBSTRING_32_ARRAY

inherit
	EL_SUBSTRING_32_ARRAY_IMPLEMENTATION

create
	make_from_unencoded, make_empty, make_from_other

feature {NONE} -- Initialization

	make_empty
		do
			area := Empty_unencoded
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
			i, i_final, o_final, j_final, delta: INTEGER
			l_area, o_area, joined_area: like area
		do
			if not_empty then
				l_area := area; i_final := count * 2 + 1
				o_area := other.area; o_final := other.count * 2 + 1
				if last_upper + 1 = other.first_lower then
					-- merge two intervals by subtracting `delta' bytes
					delta := 2
				end
				j_final := count * 2 + other.count * 2 - delta + 1
				create joined_area.make_empty (l_area.count + o_area.count - delta - 1)
				-- copy `count' + intervals
				joined_area.copy_data (l_area, 0, 0, i_final)
				increment_count (joined_area, other.count - (delta // 2))

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
			valid_merge_count: old (not_empty and then last_upper + 1 = other.first_lower) implies count = old count + other.count - 1
			valid_count: old (not_empty and then last_upper + 1 < other.first_lower) implies count = old count + other.count
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

feature {EL_ZCODE_CONVERSION} -- Contract Support

	is_unencoded_valid: BOOLEAN
		do
			Result := True
		end

	overlaps (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := not (end_index < first_lower) and then not (start_index > last_upper)
		end

end