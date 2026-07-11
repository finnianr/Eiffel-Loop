note
	description: "[
		An immutable string that uses a C allocated character array instead of ${SPECIAL [CHARACTER_8]}
		(BORROWED FROM Eiffel-Loop)
	]"
	notes: "[
		WARNING: this is a fixed length string and not null terminated.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-06-29 15:50:02 GMT (Monday 29th June 2026)"
	revision: "5"

class
	C_STRING_8

inherit
	MANAGED_POINTER
		rename
			item as area,
			share_from_pointer as make_shared
		export
			{NONE} all
			{STRING_HANDLER} make_shared
			{C_STRING_8} area
			{ANY} count
		undefine
			is_equal
		end

	COMPARABLE
		undefine
			copy
		end

	STRING_HANDLER
		undefine
			copy, is_equal
		end

	DEBUG_OUTPUT
		undefine
			copy, is_equal
		end

	C_STRING_8_API
		undefine
			copy, is_equal
		end

	EL_ZLIB_CRC_32_API
		undefine
			copy, is_equal
		end

create
	make, make_filled, make_from_string, make_shared, make_empty

convert
	make_from_string ({STRING_8})

feature {NONE} -- Initialization

	make_empty
		do
			make (0)
		end

	make_filled (c: CHARACTER_8; n: INTEGER)
			-- Create string of length `n' filled with `c'.
		require
			valid_count: n >= 0
		local
			i: INTEGER
		do
			make (n)
			from until i = n loop
				put_character (c, i)
				i := i + 1
			end
		ensure
			count_set: count = n
			filled: occurrences (c) = count
		end

	make_from_string (s: STRING_8)
		-- Initialize buffer with the contents of `s'.
		do
			make_from_pointer (s.area.base_address, s.count)
		ensure
			count_set: count = s.count
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current string lexicographically less than `other'?
		do
			Result := c_strcmp_n (area, count, other.area, other.count) < 0
		end

feature -- Access

	item alias "[]" (i: INTEGER): CHARACTER_8
		-- Character at position `i'.
		require
			valid_index: valid_index (i)
		do
			Result := c_read_character_8 (area, i - 1)
		end

feature -- Access

	crc_32: NATURAL
		-- CRC-32/ISO-HDLC
		do
			Result := crc_32_continue (CRC_initial)
		end

	crc_32_continue (a_value: NATURAL_64): NATURAL
		-- continue adding to a previously calculated CRC-32/ISO-HDLC `a_value'
		local
			value: NATURAL
		do
			inspect a_value
				when CRC_initial then
					value := c_crc_32_seed
			else
				value := a_value.to_natural_32
			end
			Result := c_crc_32 (value, area, count)
		end

feature -- Measurement

	index_of (c: CHARACTER_8; start_index: INTEGER): INTEGER
		-- Position of first occurrence of `c' at or after `start_index';
		-- 0 if none.
		require
			start_large_enough: start_index >= 1
			start_small_enough: start_index <= count + 1
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			if start_index <= l_count then
				from i := start_index - 1 until i = l_count or else c_read_character_8 (l_area, i) = c loop
					i := i + 1
				end
				if i < l_count then
				-- We add +1 due to the area starting at 0 and not at 1
					Result := i + 1
				end
			end
		ensure
			same_as_string_8: Result = to_string.index_of (c, start_index)
		end


	match_count (other: SPECIAL [CHARACTER_8]; offset: INTEGER): INTEGER
		-- count of characters in `other' from `offset' matching those in `area'
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			l_count := count.min (other.count - offset)
			l_area := area
			from i := 0; until i = l_count loop
				if c_read_character_8 (l_area, i) = other [offset + i] then
					Result := Result + 1
					i := i + 1
				else
					i := l_count -- break
				end
			end
		end

	occurrences (c: CHARACTER_8): INTEGER
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
		ensure
			same_as_string_8: Result = to_string.occurrences (c)
		end

feature -- Status report

	same_characters (other: SPECIAL [CHARACTER_8]; offset: INTEGER): BOOLEAN
		-- `True' if characters in `other' from `offset' match those in `Current'
		local
			l_count: INTEGER
		do
			l_count := count
			if other.valid_index (offset + l_count - 1) then
				Result := c_memory_compare (area, other.item_address (offset), l_count)
			end
		end

	starts_with (other: C_STRING_8): BOOLEAN
		-- Does `area' start with the same bytes as `other.area'?
		do
			if other.count <= count then
				Result := c_memory_compare (area, other.area, other.count)
			end
		ensure
			same_as_string: Result = to_string.starts_with (other.to_string)
		end

	valid_index (i: INTEGER): BOOLEAN
		-- Is `i' within the bounds of the string?
		do
			Result := (i > 0) and (i <= count)
		ensure
			definition: Result = (1 <= i and i <= count)
		end

feature -- Conversion

	to_string, debug_output: STRING_8
		do
			create Result.make (count)
			append_to_string_area (Result.area, 0)
			Result.set_count (count)
		ensure then
			round_trip: is_equal (new_string (Result))
		end

feature -- Basic operations

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

	substring (start_index, end_index: INTEGER): like Current
		-- substring with shared character buffer containing all characters at indices
		-- between `start_index' and `end_index'
		local
			l_count: INTEGER
		do
			if (1 <= start_index) and (start_index <= end_index) and (end_index <= count) then
				l_count := end_index - start_index + 1
				create Result.make_shared (area + (start_index - 1), l_count)
			else
				create Result.make_empty
			end
		ensure
			substring_count: Result.count = end_index - start_index + 1 or Result.count = 0
			first_code: Result.count > 0 implies Result [1] = item (start_index)
			recurse: Result.count > 0 implies Result.substring (2, Result.count) ~ substring (start_index + 1, end_index)
		end

	new_string (str: STRING_8): like Current
		do
			Result := str
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
