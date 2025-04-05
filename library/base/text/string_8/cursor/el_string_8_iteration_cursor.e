note
	description: "External forward one-step iteration cursor for ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 18:23:54 GMT (Saturday 5th April 2025)"
	revision: "23"

class
	EL_STRING_8_ITERATION_CURSOR

inherit
	EL_STRING_ITERATION_CURSOR

	STRING_8_ITERATION_CURSOR
		rename
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		export
			{EL_SHARED_STRING_8_CURSOR, STRING_HANDLER} area, index_lower, index_upper
		end

	EL_STRING_BIT_COUNTABLE [STRING_8]

	EL_STRING_8_CONSTANTS
		rename
			empty_string_8 as empty_target
		end

create
	make_empty

feature -- Transforms

	filtered (included: PREDICATE [CHARACTER]): STRING
		do
			create Result.make (target.count)
			area.do_if_in_bounds (agent Result.extend, included, index_lower, index_upper)
			Result.trim
		end

feature -- Status query

	has_character_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurs between `start_index' and `end_index'
		local
			count, i, i_final: INTEGER; c: CHARACTER_8
		do
			if uc.is_character_8 and then target.valid_index (start_index) then
				c := uc.to_character_8
				count := target.count.min (end_index) - start_index + 1
				i := start_index + index_lower - 1
				i_final := i + count
				if attached area as l_area then
					from until i = i_final or Result loop
						Result := l_area [i] = c
						i := i + 1
					end
				end
			end
		end

	is_ascii_substring (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `target.substring (start_index, end_index)'
		-- are in the ASCII character set: 0 .. 127
		require
			valid_end_index: end_index <= target_count
		local
			c_8: EL_CHARACTER_8_ROUTINES; l_last_index: INTEGER
		do
			l_last_index := index_upper - (target.count - end_index)
			Result := c_8.is_ascii_area (area, index_lower + start_index - 1, l_last_index)
		end

feature -- Measurement

	target_count: INTEGER
		do
			Result := target.count
		end

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		local
			i, i_final: INTEGER
		do
			if attached area as l_area then
				i_final := source_index + index_lower + n
				from i := source_index + index_lower until i = i_final loop
					destination.extend (l_area [i].to_character_32)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	i_th_character_8 (a_area: like area; i: INTEGER): CHARACTER_8
		do
			Result := a_area [i]
		end

	i_th_character_32 (a_area: like area; i: INTEGER): CHARACTER_32
		do
			Result := a_area [i]
		end

	i_th_unicode (a_area: like area; i: INTEGER): NATURAL
		do
			Result := a_area [i].natural_32_code
		end

	is_i_th_eiffel_identifier (a_area: like area; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		local
			c8: EL_CHARACTER_8_ROUTINES
		do
			Result := c8.is_i_th_eiffel_identifier (a_area, i, case_code, first_i)
		end

	last_index_of (str: STRING_8; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c.to_character_8, start_index_from_end)
		end

end