note
	description: "Implementation routines for [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-25 17:43:16 GMT (Monday 25th January 2021)"
	revision: "8"

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
			create list.make (l_area.item (0).to_integer_32)
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
			Result.extend (0)
		end

	new_joined_area (area_1, area_2: like area; delta: INTEGER): like area
		require
			even_delta: delta \\ 2 = 0
			valid_areas: area_1.count > 0 and area_2.count > 0
		do
			create Result.make_empty (area_1.count + area_2.count - delta - 1)
			Result.extend (0)
			increment_count (Result, (area_1 [0] + area_2 [0]).to_integer_32 - (delta // 2))
		end

feature {EL_SUBSTRING_32_ARRAY_IMPLEMENTATION} -- Access

	area: SPECIAL [NATURAL]
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
				a_area.extend (lower.to_natural_32)
				a_area.extend (upper.to_natural_32)
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
					l_area [i] := new_c.natural_32_code
				end
				i := i + 1
			end
		end

	character_count: INTEGER
		-- sum of all substring counts
		deferred
		end

	first_index (a_area: SPECIAL [NATURAL]): INTEGER
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
			Result := (a_area [i + 1] - a_area [i]).to_integer_32 + 1
		end

	lower_bound, value (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i).to_integer_32
		end

	put_interval (a_area: like area; i, lower, upper: INTEGER)
		do
			a_area.put (lower.to_natural_32, i)
			a_area.put (upper.to_natural_32, i + 1)
		end

	put_lower (a_area: like area; i, lower: INTEGER)
		do
			a_area.put (lower.to_natural_32, i)
		end

	put_upper (a_area: like area; i, upper: INTEGER)
		do
			a_area.put (upper.to_natural_32, i + 1)
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
			Result := a_area.item (i + 1).to_integer_32
		end

feature {NONE} -- Constants

	Empty_area: SPECIAL [NATURAL]
		once
			create Result.make_empty (1)
			Result.extend (0)
		end

	Once_iterator: SPECIAL [EL_SUBSTRING_32_ARRAY_ITERATOR]
		once
			create Result.make_empty (2)
			Result.extend (create {EL_SUBSTRING_32_ARRAY_ITERATOR})
			Result.extend (create {EL_SUBSTRING_32_ARRAY_ITERATOR})
		end

end