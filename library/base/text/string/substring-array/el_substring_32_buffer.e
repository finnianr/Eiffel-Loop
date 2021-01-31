note
	description: "Temporary fast buffer contents of a [$source EL_SUBSTRING_32_ARRAY]"
	notes: "[
		Average execution times (in ascending order)
		{EL_SUBSTRING_32_BUFFER}.put_unicode        : 0.105 millisecs
		{EL_EXTENDABLE_UNENCODED_CHARACTERS}.extend : +2%
		{EL_SUBSTRING_32_BUFFER}.extend_unicode     : +7%
		{EL_SUBSTRING_32_LIST}.put_unicode          : +17%
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-31 9:25:36 GMT (Sunday 31st January 2021)"
	revision: "2"

class
	EL_SUBSTRING_32_BUFFER

inherit
	EL_EXTENDABLE_AREA [NATURAL]
		export
			{EL_SUBSTRING_32_CONTAINER} area
		undefine
			not_empty
		end

	EL_SUBSTRING_32_CONTAINER
		rename
			count as substring_count
		end

	EL_ZCODE_CONVERSION

	EL_SUBSTRING_32_ARRAY_IMPLEMENTATION
		export
			{NONE} all
			{STRING_HANDLER} Substring_buffer
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			create area.make_empty (n.max (1))
			wipe_out
		end

feature -- Measurement

	character_count: INTEGER
		do
			Result := area.count - substring_count * 2 - 1
		end

	substring_count: INTEGER
		do
			Result := area.item (0).to_integer_32
		end

feature -- Access

	first_lower: INTEGER
		require
			not_empty: not_empty
		do
			Result := lower_bound (area, 1)
		end

	first_upper: INTEGER
		require
			not_empty: not_empty
		do
			Result := upper_bound (area, 1)
		end

	last_upper: INTEGER
		do
			if last_upper_index.to_boolean then
				Result := area.item (last_upper_index).to_integer_32
			else
				Result := (1).opposite
			end
		end

	last_upper_index: INTEGER

feature -- Element change

	append (array: EL_SUBSTRING_32_ARRAY)
		local
			i, lower, upper, i_final, offset, char_count: INTEGER; l_area_array, l_area: like area
		do
			l_area := area
			l_area := big_enough (l_area, array.count * 2 + array.character_count)
			l_area_array := array.area; i_final := first_index (l_area_array)
			offset := i_final
			from i := 1 until i = i_final loop
				lower := lower_bound (l_area_array, i); upper := upper_bound (l_area_array, i)
				char_count := upper - lower + 1
				l_area.extend (lower.to_natural_32)
				l_area.extend (upper.to_natural_32)
				if i + 2 = i_final then
					last_upper_index := l_area.count - 1
				end
				l_area.copy_data (l_area_array, offset, l_area.count, char_count)
				offset := offset + char_count
				i := i + 2
			end
			increment_count (l_area, array.count)
		ensure
			count_incremented: old substring_count + array.count = substring_count
		end

	append_substring (str: EL_SUBSTRING_32_ARRAY; start_index, end_index: INTEGER)
		do
			str.append_substrings_into (Current, start_index, end_index)
			shift ((start_index - 1).opposite)
		end

	put_character (c: CHARACTER_32; a_index: INTEGER)
		do
			put_unicode (c.natural_32_code, a_index)
		end

	put_unicode (a_code: NATURAL; index: INTEGER)
		local
			area_count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			if last_upper + 1 = index then
				l_area := big_enough (l_area, area_count + 1)
				l_area.put (index.as_natural_32, last_upper_index)
				l_area.extend (a_code)
			else
				l_area := big_enough (l_area, area_count + 3)
				l_area [0] := l_area [0] + 1
				l_area.extend (index.as_natural_32)
				l_area.extend (index.as_natural_32)
				l_area.extend (a_code)
				last_upper_index := area_count + 1
			end
		end

	put_z_code (a_z_code: NATURAL; index: INTEGER)
		do
			put_unicode (z_code_to_unicode (a_z_code), index)
		end

feature -- Status change

	shift (n: INTEGER)
		local
			i, area_count, lower, upper: INTEGER; l_area: like area
		do
			if n.abs.to_boolean then
				l_area := area; area_count := l_area.count
				from i := 1 until i = area_count loop
					lower := lower_bound (l_area, i) + n
					upper := upper_bound (l_area, i) + n
					put_interval (l_area, i, lower, upper)
					i := i + upper - lower + 3
				end
			end
		end

feature -- Transformation

	to_substring_area: like area
		local
			i, j, lower, upper, area_count, char_count, count: INTEGER; l_area: like area
		do
			l_area := area; area_count := l_area.count
			count := l_area.item (i).to_integer_32
			create Result.make_empty (area_count)
			Result.fill_with (count.to_natural_32, 0, count * 2)

			from i := 1; j := 1 until i = area_count loop
				lower := lower_bound (l_area, i); upper := upper_bound (l_area, i)
				char_count := upper - lower + 1
				put_interval (Result, j, lower, upper)
				Result.copy_data (l_area, i + 2, Result.count, char_count)
				i := i + char_count + 2
				j := j + 2
			end
		end

	to_substring_array: EL_SUBSTRING_32_ARRAY
		do
			create Result.make_from_area (to_substring_area)
		end

feature -- Removal

	wipe_out
		do
			area.wipe_out
			area.extend (0)
			last_upper_index := 0
		end

feature {EL_SUBSTRING_32_CONTAINER} -- Implementation

	append_interval (a_area: SPECIAL [NATURAL]; a_lower, a_upper, offset: INTEGER)
		local
			l_count: INTEGER; l_area: like area
		do
			l_count := a_upper - a_lower + 1
			l_area := area
			l_area := big_enough (l_area, l_count + 2)
			l_area.extend (a_lower.to_natural_32); l_area.extend (a_upper.to_natural_32)
			increment_count (l_area, 1)
			last_upper_index := l_area.count - 1
			l_area.copy_data (a_area, offset, l_area.count, l_count)
		ensure
			count_incremented: old substring_count + 1 = substring_count
		end

invariant
	valid_last_upper_index: substring_count > 0 implies last_upper_index + interval_count (area, last_upper_index - 1) + 1 = area.count
end