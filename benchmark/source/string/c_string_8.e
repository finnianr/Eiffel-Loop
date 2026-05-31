note
	description: "[
		An immutable string that uses a C allocated character array instead of ${SPECIAL [CHARACTER_8]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-05-30 12:41:02 GMT (Saturday 30th May 2026)"
	revision: "2"

class
	C_STRING_8

inherit
	MANAGED_POINTER
		rename
			item as area,
			share_from_pointer as make_shared
		export
			{NONE} all
			{C_STRING_8} area
			{ANY} count, is_equal
		end

	STRING_HANDLER
		undefine
			copy, is_equal
		end

	DEBUG_OUTPUT
		undefine
			copy, is_equal
		end

create
	make_from_string, make_shared, make_empty

convert
	make_from_string ({STRING_8})

feature {NONE} -- Initialization

	make_empty
		do
			make (0)
		end

	make_from_string (s: STRING_8)
		-- Initialize buffer with the contents of `s'.
		do
			make_from_pointer (s.area.base_address, s.count)
		ensure
			count_set: count = s.count
		end

feature -- Access

	item alias "[]" (i: INTEGER): CHARACTER_8
		-- Character at position `i'.
		require
			valid_index: valid_index (i)
		do
			Result := read_character_8 (area, i - 1)
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
				from i := start_index - 1 until i = l_count or else read_character_8 (l_area, i) = c loop
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

	occurrences (c: CHARACTER_8): INTEGER
		-- Number of times `c' appears in `area'
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				if read_character_8 (l_area, i) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		ensure
			same_as_string_8: Result = to_string.occurrences (c)
		end

feature -- Status report

	starts_with (other: C_STRING_8): BOOLEAN
		-- Does `area' start with the same bytes as `other.area'?
		do
			if other.count <= count then
				Result := memory_compare (area, other.area, other.count)
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
		local
			i, l_count: INTEGER; l_area: POINTER
		do
			create Result.make (count)
			Result.set_count (count)
			if attached Result.area as area_out then
				l_area := area; l_count := count
				from i := 0 until i = l_count loop
					area_out [i] := read_character_8 (l_area, i)
					i := i + 1
				end
			end
		ensure then
			round_trip: is_equal (Result)
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

feature {NONE} -- Implementation

	frozen memory_compare (p1, p2: POINTER; n: INTEGER): BOOLEAN
		-- True if first `n' bytes at `p1' and `p2' are identical.
		external
			"C inline use <string.h>"
		alias
			"return (memcmp ($p1, $p2, $n) == 0);"
		end

	frozen read_character_8 (a_area: POINTER; i: INTEGER): CHARACTER_8
			-- Character at offset `i' in buffer `a_area'.
		require
			valid_index: valid_index (i + 1)
		external
			"C inline"
		alias
			"return ((EIF_CHARACTER_8 *)$a_area)[$i];"
		end

end