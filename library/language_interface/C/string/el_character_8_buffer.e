note
	description: "${MANAGED_POINTER} of ${CHARACTER_8} data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

	date: "2026-08-27 13:11:00 GMT (Thursday 27th August 2026)"
	revision: "1"

class
	EL_CHARACTER_8_BUFFER

inherit
	MANAGED_POINTER
		rename
			count as capacity,
			item as area,
			share_from_pointer as make_shared
		export
			{EL_CHARACTER_8_BUFFER} area
			{STRING_HANDLER} make_shared
			{NONE} all
		undefine
			is_equal
		redefine
			append, make_shared
		end

	READABLE_INDEXABLE [CHARACTER]
		rename
			valid_index as valid_item_index
		undefine
			copy, is_equal
		end

	STRING_HANDLER
		undefine
			copy, is_equal
		end

	EL_STRING_H_C_API
		undefine
			copy, is_equal
		end

	COMPARABLE
		undefine
			copy
		end

create
	make, make_empty, make_filled, make_filled_default, make_from_string, make_shared

feature {NONE} -- Initialization

	make_empty
		do
			make_shared (default_pointer, 0)
		end

	make_filled_default (n: INTEGER)
		-- make buffer with filled with default '%U' character
		require
			valid_count: n >= 0
		do
			make (n); count := n
		ensure
			count_set: count = n
		end

	make_filled (c: CHARACTER_8; n: INTEGER)
			-- Create string of length `n' filled with `c'.
		do
			make_filled_default (n)
			area.memory_set (c.code, n)
		ensure
			filled: occurrences (c) = count
		end

	make_from_string (s: STRING_8)
		-- Initialize buffer with the contents of `s' and null terminate
		do
			make (s.count)
			area.memory_copy (s.area.base_address, s.count)
			count := s.count
		ensure
			same_characters: to_string ~ s
		end

	make_shared (a_ptr: POINTER; n: INTEGER)
		do
			Precursor (a_ptr, n)
			count := n
		end

feature -- Access

	item alias "[]" (i: INTEGER): CHARACTER_8 assign put
		-- character at position `i' (indices begin at 0)
		do
			Result := c_read_character_8 (area, i)
		end

feature -- Element change

	put (c: CHARACTER; i: INTEGER)
		-- Replace `i'-th item by `v' (Indices begin at 0)
		do
			c_put_character_8 (area, c, i)
		ensure
			inserted: item (i) = c
			same_count: count = old count
			same_capacity: capacity = old capacity
		end

feature -- Measurement

	count: INTEGER

	frozen leading_white_space (start_index, end_index: INTEGER): INTEGER
		-- count of leading whitespace in `area' from `start_index' to `end_index'
		require
			valid_range: valid_range (start_index, end_index)
		local
			i: INTEGER; l_area: POINTER
		do
			l_area := area
			from i := start_index until i > end_index loop
				if c_read_character_8 (l_area, i).is_space then
					Result := Result + 1; i := i + 1
				else
					i := end_index + 1 -- break
				end
			end
		end


	Lower: INTEGER = 0
			-- Minimum index of Current.

	frozen index_of (c: CHARACTER_8; start_index, end_index: INTEGER): INTEGER
		-- Position of first occurrence of `c' at or after `start_index';
		-- -1 if none.
		require
			valid_range: valid_range (start_index, end_index)
		local
			i, i_upper: INTEGER; l_area: POINTER
		do
			l_area := area
			i_upper := (count - 1).min (end_index).max (0)
			from i := start_index until i > i_upper or else c_read_character_8 (l_area, i) = c loop
				i := i + 1
			end
			if i > end_index then
				Result := -1
			else
				Result := i
			end
		end

	frozen match_count (offset: INTEGER; string: STRING): INTEGER
		-- count of characters in `area' from `offset' matching those from start of `string'
		require
			valid_offset: valid_index (offset)
			inside_area: valid_index (offset + string.count - 1)
		local
			i, i_final: INTEGER; string_area: SPECIAL [CHARACTER_8]; l_area: POINTER
		do
			l_area := area; string_area := string.area
			i_final := string_area.count.min (count - offset).max (0)
			from i := 0; until i = i_final loop
				if c_read_character_8 (l_area, i + offset) = string_area [i] then
					Result := Result + 1
					i := i + 1
				else
					i := i_final -- break
				end
			end
		end

	frozen occurrences (c: CHARACTER_8): INTEGER
		-- Number of times `c' appears in `area'
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				if c_read_character_8 (l_area, i) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	upper: INTEGER
			-- Maximum index of Current.
		do
			Result := count - 1
		end

feature -- Status query

	frozen filled_with (c: CHARACTER_8; start_index, end_index: INTEGER): BOOLEAN
		-- Are all items between index `start_index' and `end_index' set to `c'?
		require
			valid_range: valid_range (start_index, end_index)
		local
			i: INTEGER; l_area: POINTER
		do
			Result := True; l_area := area
			from i := start_index until i > end_index or not Result loop
				Result := c_read_character_8 (l_area, i) = c
				i := i + 1
			end
		end

	frozen has_upper: BOOLEAN
		-- `True' if string has uppercase character
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count or Result loop
				if c_read_character_8 (l_area, i).is_upper then
					Result := True
				else
					i := i + 1
				end
			end
		end

	frozen is_null_terminated: BOOLEAN
		do
			Result := capacity > count and then c_read_character_8 (area, count) = '%U'
		end

	frozen is_whitespace: BOOLEAN
		-- `True' if entire string is whitespace
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			l_area := area; l_count := count
			Result := True
			from i := 0 until i = l_count or not Result loop
				if c_read_character_8 (l_area, i).is_space then
					i := i + 1
				else
					Result := False
				end
			end
		end

	frozen is_white_space_slice (start_index, end_index: INTEGER): BOOLEAN
		-- count of leading whitespace in `area' from `start_index' to `end_index'
		require
			valid_range: valid_range (start_index, end_index)
		local
			i, i_upper: INTEGER; l_area: POINTER
		do
			l_area := area
			Result := True
			i_upper := (count - 1).min (end_index)
			from i := start_index until i > i_upper loop
				if c_read_character_8 (l_area, i).is_space then
					i := i + 1
				else
					Result := False
					i := end_index + 1 -- break
				end
			end
		end

	valid_index, valid_item_index (i: INTEGER): BOOLEAN
			-- Is `i' within the bounds of Current?
		do
			Result := 0 <= i and i < count
		end

	valid_range (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `start_index' and `end_index' define a valid `slice' range
		do
			if start_index >= 0 and then start_index <= end_index + 1 then
				Result := end_index < count
			end
		end

feature -- String comparison

	is_less alias "<" (other: like Current): BOOLEAN
		-- Is current string lexicographically less than `other'?
		do
			Result := c_string_8_compare (area, count, other.area, other.count) < 0
		end

 	frozen same_characters (start_index, end_index: INTEGER; string: STRING_8): BOOLEAN
			-- Are characters of within bounds `start_index' and `end_index'
			-- identical to characters of `string'.
		require
			valid_range: valid_range (start_index, end_index)
		local
			slice_count: INTEGER
		do
			slice_count := end_index - start_index + 1
			if slice_count = string.count and then start_index + slice_count <= count then
				Result := c_memory_compare (area + start_index, string.area.base_address, slice_count)
			end
		ensure
			same_characters: Result implies shared_slice (start_index, end_index).to_string.same_string (string)
		end

	frozen same_caseless_characters (start_index, end_index: INTEGER; string: STRING): BOOLEAN
		-- `True' if characters in `area' from `start_index' to `end_index' match those in `string' regardless of case
		local
			i, j: INTEGER; c_i, c_j: CHARACTER; l_area: POINTER
		do
			if end_index - start_index + 1 = string.count and then attached string.area as string_area then
				l_area := area
				Result := True
				from i := start_index until i > end_index loop
					c_i := c_read_character_8 (l_area, i); c_j := string_area [j]
					if c_i = c_j or else c_i.as_lower =  c_j.as_lower then
						i := i + 1
						j := j + 1
					else
						Result := False
						i := end_index + 1 -- break
					end
				end
			end
		ensure
			definition: Result implies shared_slice (start_index, end_index).to_string.same_caseless_characters (string, 1, string.count, 1)
		end

	frozen same_items (other: EL_CHARACTER_8_BUFFER; source_index, destination_index, n: INTEGER): BOOLEAN
			-- Are the `n' elements of `other' from `source_index' position the same as
			-- the `n' elements of `Current' from `destination_index'?
			-- (Use reference equality for comparison.)
		require
			source_index_non_negative: source_index >= 0
			destination_index_non_negative: destination_index >= 0
			n_non_negative: n >= 0
			n_is_small_enough_for_source: source_index + n <= other.count
			n_is_small_enough_for_destination: destination_index + n <= count
		do
			Result := c_memory_compare (area + destination_index, other.area + source_index, n)
		ensure
			valid_on_empty_area: n = 0 implies Result
		end

	frozen same_string (str: STRING_8): BOOLEAN
		-- Does `area' start with the same bytes as `other.area'?
		do
			if count = str.count then
				Result := c_memory_compare (area, str.area.base_address, str.count)
			end
		ensure
			same_as_string: Result = to_string.same_string (str)
		end

	frozen starts_with (other: EL_CHARACTER_8_BUFFER): BOOLEAN
		-- Does `area' start with the same bytes as `other.area'?
		do
			if other.count <= count then
				Result := c_memory_compare (area, other.area, other.count)
			end
		ensure
			same_as_string: Result = to_string.starts_with (other.to_string)
		end

	starts_with_string (start_index: INTEGER; str: STRING_8): BOOLEAN
		-- Does `area' start with the same bytes as `str' from `start_index' ?
		require
			valid_index: valid_index (start_index)
		do
			if start_index + str.count <= count then
				Result := c_memory_compare (area + start_index, str.area.base_address, str.count)
			end
		ensure
			same_as_string: Result implies same_characters (start_index, start_index + str.count - 1, str)
		end

feature -- Conversion

	to_string: STRING_8
		do
			create Result.make (count)
			append_to_string_area (Result.area, 0)
			Result.set_count (count)
		ensure then
			round_trip: is_equal (new_string (Result))
		end

feature -- Output

	frozen append_slice_to_string_8 (str: STRING_8; start_index, end_index: INTEGER)
		-- append contents of `area' from `start_index' to `end_index' to `str'
		require
			valid_range: valid_range (start_index, end_index)
		local
			slice_count, new_count: INTEGER
		do
			slice_count := end_index - start_index + 1; new_count := str.count + slice_count
			str.grow (new_count)
			c_memory_copy (str.area.item_address (str.count), area + start_index, slice_count)
			str.area [new_count] := '%U'
			str.set_count (new_count)
		ensure
			valid_count: str.count = old str.count + end_index - start_index + 1
			appended: str.ends_with (shared_slice (start_index, end_index).to_string)
		end

	append_to_string_8 (str: STRING_8)
		local
			new_count: INTEGER
		do
			new_count := str.count + count
			str.grow (new_count)
			append_to_string_area (str.area, str.count)
			str.set_count (new_count)
		end

feature -- Duplication

	shared_slice (start_index, end_index: INTEGER): like Current
		require
			valid_range: valid_range (start_index, end_index)
		local
			l_count: INTEGER
		do
			l_count := (end_index - start_index + 1).min (capacity - start_index).max (0)
			create Result.make_shared (area + start_index, l_count)
		end

	slice (start_index, end_index: INTEGER): like Current
		require
			valid_range: valid_range (start_index, end_index)
		local
			l_count: INTEGER
		do
			l_count := (end_index - start_index + 1).min (capacity - start_index).max (0)
			create Result.make (l_count)
			Result.copy_data (Current, start_index, 0, l_count)
		end

	new_string (str: STRING_8): like Current
		do
			create Result.make_from_string (str)
		end

feature -- Element change

	append (buffer: EL_CHARACTER_8_BUFFER)
		local
			new_count: INTEGER
		do
			new_count := count + buffer.count
			if new_count > capacity then
				capacity := new_count + (capacity // 2).max (5) -- with additional space
				area := area.memory_realloc (capacity)
				if area.is_default_pointer then
					(create {EXCEPTIONS}).raise ("No more memory")
				end
			end
			(area + count).memory_copy (buffer.area, buffer.count)
			count := new_count
		end

	copy_data (other: EL_CHARACTER_8_BUFFER; source_index, destination_index, n: INTEGER)
			-- Copy `n' elements of `other' from `source_index' position to Current at
			-- `destination_index'. Other elements of Current remain unchanged.
		require
			source_index_non_negative: source_index >= 0
			destination_index_non_negative: destination_index >= 0
			destination_index_in_bound: destination_index <= count
			n_non_negative: n >= 0
			n_is_small_enough_for_source: source_index + n <= other.count
			n_is_small_enough_for_destination: destination_index + n <= capacity
		do
			if other = Current then
				c_memory_move (area + destination_index, other.area + source_index, n)
			else
				c_memory_copy (area + destination_index, other.area + source_index, n)
				count := destination_index + n
			end
		ensure
			copied: other /= Current implies same_items (other, source_index, destination_index, n)
		end

	extend (c: CHARACTER)
			-- Add `v' at index `count'.
		require
			count_small_enough: count < capacity
		do
			put_character (c, count)
			count := count + 1
		ensure
			count_increased: count = old count + 1
			same_capacity: capacity = old capacity
			inserted: read_character (count - 1) = c
		end

	frozen extend_utf_8 (cp: INTEGER)
		-- extend Unicode code point `cp' as UTF-8 sequence
		require
			big_enough: capacity - count >= 4
		local
			new_count: INTEGER; l_area: POINTER
		do
			l_area := area
			if cp <= 0x7F then
				new_count := count + 1
				c_put_character_8 (l_area, cp.to_character_8, new_count - 1)
			elseif cp <= 0x7FF then
				new_count := count + 2
				c_put_character_8 (l_area, (0xC0 | (cp |>> 6)).to_character_8, new_count - 2)
				c_put_character_8 (l_area, (0x80 | (cp & 0x3F)).to_character_8, new_count - 1)
			elseif cp <= 0xFFFF then
				new_count := count + 3
				c_put_character_8 (l_area, (0xE0 | (cp |>> 12)).to_character_8, new_count - 3)
				c_put_character_8 (l_area, (0x80 | ((cp |>> 6) & 0x3F)).to_character_8, new_count - 2)
				c_put_character_8 (l_area, (0x80 | (cp & 0x3F)).to_character_8, new_count - 1)
			else
				new_count := count + 4
				c_put_character_8 (l_area, (0xF0 | (cp |>> 18)).to_character_8, new_count - 4)
				c_put_character_8 (l_area, (0x80 | ((cp |>> 12) & 0x3F)).to_character_8, new_count - 3)
				c_put_character_8 (l_area, (0x80 | ((cp |>> 6) & 0x3F)).to_character_8, new_count - 2)
				c_put_character_8 (l_area, (0x80 | (cp & 0x3F)).to_character_8, new_count - 1)
			end
			count := new_count
		ensure
			valid_utf_8_appended:
				attached {UTF_CONVERTER}.utf_8_0_subpointer_to_escaped_string_32 (Current, old count, count - 1, False) as s_32
				and then s_32.count = 1 and then s_32.code (1) = cp.to_natural_32
		end

	remove_head (n: INTEGER)
		require
			n_less_than_or_equal: n <= count
		do
			if is_shared and n <= count then
				area := area + n
				count := count - n
			end
		end

feature {NONE} -- Implementation

	append_to_string_area (area_out: SPECIAL [CHARACTER]; offset: INTEGER)
		require
			big_enough_str: offset + count <= area_out.capacity - 1
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				area_out [offset + i] := c_read_character_8 (l_area, i)
				i := i + 1
			end
		end

end
