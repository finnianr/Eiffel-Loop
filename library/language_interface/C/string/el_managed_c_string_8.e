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
	date: "2026-07-30 07:48:00 GMT (Thursday 30th July 2026)"
	revision: "6"

class
	EL_MANAGED_C_STRING_8

inherit
	EL_CHARACTER_8_BUFFER
		rename
			index_of as index_of_between,
			valid_index as valid_zero_index,
			valid_item_index as valid_index
		export
			{NONE} all
		redefine
			item, valid_index
		end

create
	make, make_filled, make_from_string, make_shared, make_empty

convert
	make_from_string ({STRING_8})

feature -- Access

	item alias "[]" (i: INTEGER): CHARACTER_8
		-- Character at position `i'.
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

feature -- Status query

	has_substring_at (other: STRING_8; index: INTEGER): BOOLEAN
		-- `True' if characters of `other' occur at `index'
		require
			valid_index: valid_index (index)
		local
			other_count: INTEGER
		do
			other_count := other.count
			if valid_index (index) and then valid_index (index + other_count - 1) then
				Result := c_memory_compare (area + (index - 1), other.area.base_address, other_count)
			end
		end

	valid_index (i: INTEGER): BOOLEAN
		-- Is `i' within the bounds of the string?
		do
			Result := 1 <= i and i <= count
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

end
