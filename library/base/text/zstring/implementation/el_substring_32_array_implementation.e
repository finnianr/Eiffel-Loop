note
	description: "Implementation routines for [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-28 10:38:39 GMT (Monday 28th December 2020)"
	revision: "4"

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

feature {NONE} -- Implementation

	area: SPECIAL [NATURAL]
		deferred
		end

	interval_count (a_area: like area; i: INTEGER): INTEGER
		do
			Result := (a_area [i + 1] - a_area [i]).to_integer_32 + 1
		end

	lower_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i).to_integer_32
		end

	new_area (a_area: SPECIAL [NATURAL]; i, n: INTEGER): SPECIAL [NATURAL]
		-- copy of `a_area' with `n' zeros inserted at `i'th position
		local
			j: INTEGER
		do
			create Result.make_empty (a_area.count + n)
			Result.copy_data (a_area, 0, 0, i)
			from j := 1 until j > n loop
				Result.extend (0)
				j := j + 1
			end
			Result.copy_data (a_area, i, i + n, a_area.count - i)
		end

	put_lower (a_area: like area; i, lower: INTEGER)
		do
			a_area.put (lower.to_natural_32, i)
		end

	put_interval (a_area: like area; i, lower, upper: INTEGER)
		do
			a_area.put (lower.to_natural_32, i)
			a_area.put (upper.to_natural_32, i + 1)
		end

	put_upper (a_area: like area; i, upper: INTEGER)
		do
			a_area.put (upper.to_natural_32, i + 1)
		end

	increment_count (a_area: like area; n: INTEGER)
		require
			not_empty: a_area.count > 0
		do
			a_area.put (a_area [0] + n.to_natural_32, 0)
		end

	upper_bound (a_area: like area; i: INTEGER): INTEGER
		do
			Result := a_area.item (i + 1).to_integer_32
		end

feature {NONE} -- Constants

	Empty_unencoded: SPECIAL [NATURAL]
		once
			create Result.make_empty (1)
			Result.extend (0)
		end

end