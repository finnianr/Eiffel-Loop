note
	description: "[
		Array of unicode substrings in order of occurence in source string.
	]"
	notes: "[
		This is an experiment to try and improve on the performance of [$source EL_UNENCODED_CHARACTERS]
		
		**Conclusion**
		
		Turns out that [$source EL_UNENCODED_CHARACTERS] is marginally faster:

			Average execution times over 10000 runs (in ascending order)
			{ZSTRING}.make_general      :  0.083 millisecs
			{L1_UC_STRING}.make_general : +3%

			Average execution times over 10000 runs (in ascending order)
			{ZSTRING}.unicode      :  0.092 millisecs
			{L1_UC_STRING}.unicode : +7%

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-05 16:23:55 GMT (Saturday 5th December 2020)"
	revision: "4"

class
	SUBSTRING_32_ARRAY

create
	make

feature {NONE} -- Initialization

	make
		do
			substring_area := Empty_substring_area
		end

feature -- Access

	character_item (index: INTEGER): CHARACTER_32
		-- {EL_UNENCODED_CHARACTERS}.item
		local
			substring: like substring_area.item; i, offset: INTEGER
		do
			i := substring_index (index)
			if i >= 0 then
				substring := substring_area [i]
				offset := index - lower_index_of (substring)
				Result := substring.item (1 + offset)
			end
		end

	code_item (index: INTEGER): NATURAL
		-- {EL_UNENCODED_CHARACTERS}.code
		do
			Result := character_item (index).natural_32_code
		end

	last_upper: INTEGER
		--
		do
			Result := upper_index_of (substring_area [substring_area.upper])
		end

feature -- Basic operations

	write (area_out: SPECIAL [CHARACTER_32]; offset: INTEGER)
			-- write substrings into expanded string 'str'
		require
			string_big_enough: last_upper + offset <= area_out.count
		local
			area: like substring_area; substring: like substring_area.item
			i: INTEGER
		do
			area := substring_area
			from i := 0 until i = area.count loop
				substring := area [i]
				area_out.copy_data (substring, 1, offset + lower_index_of (substring) - 1, substring.count - 1)
				i := i + 1
			end
		end

feature -- Element change

	shift_from (index, n: INTEGER)
		-- shift intervals right by `n' characters starting from `index'.
		-- Split if interval has `index' and `index' > `lower'
		-- n < 0 shifts to the left.
		local
			i, area_count, lower, upper, insert_count, offset: INTEGER; l_area: like substring_area
			substring, insert: like substring_area.item
		do
			if n /= 0 then
				l_area := substring_area; area_count := substring_area.count
				from i := 0 until i = area_count loop
					substring := l_area [i]
					lower := lower_index_of (substring)
					if index <= lower then
						substring.put ((lower + n).to_character_32, 0)
					else
						upper := upper_index_of (substring)
						if lower < index and then index <= upper then
							-- Split the interval in two
							l_area := l_area.aliased_resized_area (l_area.count + 1)
							insert_count := upper - index + 1
							create insert.make_empty (insert_count + 1)
							insert.extend (insert_count.to_character_32)
							offset := substring_offset (substring, index)
							insert.insert_data (substring, offset, 1, insert_count)
							substring.keep_head (index - lower)

							l_area.non_overlapping_move (i + 1, i + 2, area_count - i)
							l_area.put (insert, i + 1)

							substring_area := l_area
						end
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	count: INTEGER
		do
			Result := substring_area.count
		end

	has (index: INTEGER; substring: like substring_area.item): BOOLEAN
		-- `True' if `substring' has `index'
		do
			Result := lower_index_of (substring) <= index and then index <= upper_index_of (substring)
		end

	is_after (index: INTEGER; substring: like substring_area.item): BOOLEAN
		-- `True' if `index' is after `substring'
		do
			Result := index > upper_index_of (substring)
		end

	is_before (index: INTEGER; substring: like substring_area.item): BOOLEAN
		-- `True' if `index' is before `substring'
		do
			Result := index < lower_index_of (substring)
		end

	lower_index_of (substring: like substring_area.item): INTEGER
		do
			Result := substring.item (0).code
		end

	substring_offset (substring: like substring_area.item; index: INTEGER): INTEGER
		-- `offset' of character with `index' in `substring'
		require
			substring_has_index: has (index, substring)
		do
			Result := index - substring.item (0).code + 1
		end

	substring_array: ARRAY [like substring_area.item]
		do
			create Result.make_from_special (substring_area)
		end

	substring_index (index: INTEGER): INTEGER
		-- index of substring containing string index, -1 if not found
		require
			some_substring_has_index: across substring_array as array some has (index, array.item) end
		local
			mid, lower, upper: INTEGER; found: BOOLEAN
			substring_lower, substring_upper: like substring_area.item
		do
			lower := substring_area.Lower
			upper := substring_area.upper
			substring_lower := substring_area [lower]
			substring_upper := substring_area [upper]
			if is_before (index, substring_lower) or else is_after (index, substring_upper) then
				Result := -1
			elseif has (index, substring_upper) then
				Result := upper
			elseif has (index, substring_lower) then
				Result := lower
			else
				-- binary search
				from until lower >= upper - 1 or found loop
					mid := (lower + upper) // 2
					found := has (index, substring_area [mid])
					if not found then
						if is_before (index, substring_area [mid]) then
							upper := mid
						else
							lower := mid
						end
					else
						Result := mid
					end
				end
				if not found then
					Result := -1
				end
			end
		end

	upper_index_of (substring: like substring_area.item): INTEGER
		do
			Result := lower_index_of (substring) + substring.count - 2
		end

feature {NONE} -- Internal attributes

	substring_area: like Empty_substring_area

feature {NONE} -- Constants

	Empty_substring_area: SPECIAL [SPECIAL [CHARACTER_32]]
		once
			create Result.make_empty (0)
		end

end