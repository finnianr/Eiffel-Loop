note
	description: "External forward one-step iteration cursor for [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-02 9:55:03 GMT (Thursday 2nd March 2023)"
	revision: "9"

class
	EL_STRING_8_ITERATION_CURSOR

inherit
	STRING_8_ITERATION_CURSOR
		export
			{EL_SHARED_STRING_8_CURSOR, STRING_HANDLER} area, area_first_index, area_last_index, make
		end

	EL_STRING_ITERATION_CURSOR

create
	make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make ("")
		end

feature -- Transforms

	filtered (included: PREDICATE [CHARACTER]): STRING
		do
			create Result.make (target.count)
			area.do_if_in_bounds (agent Result.extend, included, area_first_index, area_last_index)
			Result.trim
		end

feature -- Status query

	all_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		do
			Result := is_ascii_substring (1, target.count)
		end

	is_ascii_substring (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `target.substring (start_index, end_index)'
		-- are in the ASCII character set: 0 .. 127
		require
			valid_end_index: end_index <= target_count
		local
			c_8: EL_CHARACTER_8_ROUTINES; l_last_index: INTEGER
		do
			l_last_index := area_last_index - (target.count - end_index)
			Result := c_8.is_ascii_area (area, area_first_index + start_index - 1, l_last_index)
		end

	is_eiffel: BOOLEAN
		-- `True' if `target' is an Eiffel identifier
		do
			Result := is_area_eiffel_identifier (Case_lower | Case_upper)
		end

	is_eiffel_lower: BOOLEAN
		-- `True' if `target' is a lower-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier (Case_lower)
		end

	is_eiffel_upper: BOOLEAN
		-- `True' if `target' is an upper-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier (Case_upper)
		end

feature -- Measurement

	latin_1_count: INTEGER
		do
			Result := target.count
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		require else
			latin_1: uc.is_character_8
		local
			i, last_i: INTEGER; l_area: like area; c: CHARACTER
		do
			c := uc.to_character_8; last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i or else l_area [i] /= c loop
				i := i + 1
			end
			Result := i - area_first_index
		end

	leading_white_count: INTEGER
		local
			i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i or else not l_area [i].is_space loop
				i := i + 1
			end
			Result := i - area_first_index
		end

	target_count: INTEGER
		do
			Result := target.count
		end

	trailing_white_count: INTEGER
		local
			i, first_i: INTEGER; l_area: like area
		do
			first_i := area_first_index; l_area := area
			from i := area_last_index until i < first_i or else not l_area [i].is_space loop
				i := i - 1
			end
			Result := area_last_index - i
		end

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		local
			i, i_final: INTEGER
		do
			if attached area as l_area then
				i_final := source_index + area_first_index + n
				from i := source_index + area_first_index until i = i_final loop
					destination.extend (l_area [i].to_character_32)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	i_th_character_32 (a_area: SPECIAL [CHARACTER_8]; i: INTEGER): CHARACTER_32
		do
			Result := a_area [i]
		end

	is_area_eiffel_identifier (case_code: INTEGER): BOOLEAN
		local
			i, last_i: INTEGER; c: CHARACTER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			Result := True
			from i := area_last_index until i > last_i or not Result loop
				c := l_area [i]
				if i = 0 implies c.is_alpha then
					inspect c
						when 'a' .. 'z' then
							Result := (case_code & Case_lower).to_boolean

						when 'A' .. 'Z' then
							Result := (case_code & Case_upper).to_boolean

						when '0' .. '9', '_' then
							Result := True
					else
						Result := False
					end
				else
					Result := False
				end
				i := i + 1
			end
		end

	last_index_of (str: STRING_8; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c.to_character_8, start_index_from_end)
		end

feature {NONE} -- Constants

	Case_lower: INTEGER = 1

	Case_upper: INTEGER = 2

end