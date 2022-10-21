note
	description: "Implementation routines for [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-20 7:39:24 GMT (Thursday 20th October 2022)"
	revision: "14"

deferred class
	EL_SUBSTRING_32_ARRAY_IMPLEMENTATION

inherit
	EL_ZCODE_CONVERSION

feature {EL_ZCODE_CONVERSION} -- Debug

	substring_list: SPECIAL [STRING_32]
			-- Debugging output
		local
			i, j, lower, upper, char_count, i_final, offset: INTEGER; l_area: like area
			list: ARRAYED_LIST [STRING_32]; string: STRING_32
		do
			l_area := area
			create list.make (l_area.item (0).natural_32_code.to_integer_32)
			i_final := list.capacity * 2 + 1
			offset := i_final
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				create string.make (char_count + 8)
				string.append_integer (lower)
				string.append_character ('-')
				string.append_integer (upper)
				string.append_string_general (": ")
				from j := 0 until j = char_count loop
					string.extend (l_area.item (offset + j).to_character_32)
					j := j + 1
				end
				list.extend (string)
				offset := offset + char_count
				i := i + 2
			end
			Result := list.area_v2
		end

feature {NONE} -- Factory

	new_area (count, a_character_count: INTEGER): like area
		-- new area with memory of `count' substrings and `character_count' characters
		do
			create Result.make_empty (1 + count * 2 + a_character_count)
			Result.extend ('%U')
		end

	new_joined_area (area_1, area_2: like area; delta: INTEGER): like area
		require
			even_delta: delta \\ 2 = 0
			valid_areas: area_1.count > 0 and area_2.count > 0
		do
			create Result.make_empty (area_1.count + area_2.count - delta - 1)
			Result.extend ('%U')
			increment_count (Result, value (area_1, 0) + value (area_2, 0) - (delta // 2))
		end

feature {EL_SUBSTRING_32_ARRAY_IMPLEMENTATION} -- Access

	area: SPECIAL [CHARACTER_32]
		deferred
		end

feature {NONE} -- Implementation

	adjacent (i, j: INTEGER): BOOLEAN
		do
			Result := i + 1 = j
		end

	extend_interval (a_area: like area; lower, upper: INTEGER)
		local
			last_upper, index: INTEGER
		do
			if value (a_area, 0).to_boolean  then
				index := a_area.count - 2
				last_upper := upper_bound (a_area, index)
			else
				last_upper := (1).opposite
			end
			if last_upper + 1 = lower then
				put_upper (a_area, index, upper)
			else
				a_area.extend (lower.to_character_32)
				a_area.extend (upper.to_character_32)
				increment_count (a_area, 1)
			end
		end

feature {NONE} -- Implementation

	change_case (as_lower_case: BOOLEAN)
		local
			i, i_final: INTEGER; l_area: like area
			c, new_c: CHARACTER_32
		do
			l_area := area; i_final := first_index (l_area) + character_count
			from i := first_index (l_area) until i = i_final loop
				c := l_area.item (i).to_character_32
				if as_lower_case then
					new_c := c.as_lower
				else
					new_c := c.as_upper
				end
				if c /= new_c then
					l_area [i] := new_c
				end
				i := i + 1
			end
		end

	character_substring (uc: CHARACTER_32; index: INTEGER): EL_SUBSTRING_32_ARRAY
		-- substring with single character of `code' at `index'
		local
			l_area: like area
		do
			Result := Character_buffer
			l_area := Result.area
			put_interval (l_area, 1, index, index)
			l_area.put (uc, first_index (l_area))
		end

	character_count: INTEGER
		-- sum of all substring counts
		deferred
		end

	empty_substring_buffer: EL_SUBSTRING_32_BUFFER
		do
			Result := Substring_buffer
			Result.wipe_out
		end

	first_index (a_area: SPECIAL [CHARACTER_32]): INTEGER
		-- index of first character in first substring of `a_area'
		do
			Result := value (a_area, 0) * 2 + 1
		end

	increment_count (a_area: like area; n: INTEGER)
		require
			not_empty: a_area.count > 0
		do
			a_area.put (a_area [0] + n.to_natural_32, 0)
		end

	interval_count (a_area: like area; i: INTEGER): INTEGER
		do
			Result := value (a_area, i + 1) - value (a_area, i) + 1
		end

	lower_bound, value (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area [i].natural_32_code.to_integer_32
		end

	put_interval (a_area: like area; i, lower, upper: INTEGER)
		do
			a_area.put (lower.to_character_32, i)
			a_area.put (upper.to_character_32, i + 1)
		end

	put_lower (a_area: like area; i, lower: INTEGER)
		do
			a_area.put (lower.to_character_32, i)
		end

	put_upper (a_area: like area; i, upper: INTEGER)
		do
			a_area.put (upper.to_character_32, i + 1)
		end

	start (array: EL_SUBSTRING_32_ARRAY_IMPLEMENTATION): EL_SUBSTRING_32_ARRAY_ITERATOR
		do
			if array = Current then
				Result := Once_iterator [0]
			else
				Result := Once_iterator [1]
			end
			Result.start (array.area)
		end

	upper_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i + 1).natural_32_code.to_integer_32
		end

	valid_index (index: INTEGER): BOOLEAN
		local
			i, i_final: INTEGER; l_area: like area
		do
			l_area := area; i_final := first_index (l_area)
			from i := 1 until Result or else i = i_final loop
				Result := lower_bound (l_area, i) <= index and then index <= upper_bound (l_area, i)
				i := i + 2
			end
		end

feature {NONE} -- `count_greater_than_zero_flags' values

	Both_have_mixed_encoding: INTEGER = 3

	Only_current: INTEGER = 2

	Only_other: INTEGER = 1

	Neither: INTEGER = 0

feature {NONE} -- Constants

	Character_buffer: EL_SUBSTRING_32_ARRAY
		local
			l_area: like area
		once
			l_area := new_area (1, 1)
			extend_interval (l_area, 1, 1)
			l_area.extend ('%U')
			create Result.make_from_area (l_area)
		end

	Empty_area: SPECIAL [CHARACTER_32]
		once
			create Result.make_empty (1)
			Result.extend ('%U')
		end

	Once_iterator: SPECIAL [EL_SUBSTRING_32_ARRAY_ITERATOR]
		once
			create Result.make_empty (2)
			Result.extend (create {EL_SUBSTRING_32_ARRAY_ITERATOR})
			Result.extend (create {EL_SUBSTRING_32_ARRAY_ITERATOR})
		end

	Substring_buffer: EL_SUBSTRING_32_BUFFER
		once
			create Result.make (20)
		end

end