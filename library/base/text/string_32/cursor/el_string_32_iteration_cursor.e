note
	description: "External forward one-step iteration cursor for ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 8:53:39 GMT (Sunday 14th April 2024)"
	revision: "20"

class
	EL_STRING_32_ITERATION_CURSOR

inherit
	EL_STRING_ITERATION_CURSOR
		rename
			set_target as make
		end

	STRING_32_ITERATION_CURSOR
		export
			{EL_SHARED_STRING_32_CURSOR, STRING_HANDLER} area, area_first_index, area_last_index, make
		end

	EL_32_BIT_IMPLEMENTATION

	EL_SHARED_UNICODE_PROPERTY

	EL_STRING_32_CONSTANTS
		rename
			empty_string_32 as empty_target
		end

create
	make_empty

feature -- Transforms

	filtered (included: PREDICATE [CHARACTER_32]): STRING_32
		do
			create Result.make (target.count)
			area.do_if_in_bounds (agent Result.extend, included, area_first_index, area_last_index)
			Result.trim
		end

feature -- Basic operations

	append_to (destination: like area; source_index, n: INTEGER)
		do
			destination.copy_data (area, source_index + area_first_index, destination.count, n)
		end

feature -- Status query

	all_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_ascii_area (area, area_first_index, area_last_index)
		end

	has_character_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurs between `start_index' and `end_index'
		local
			count, i, i_final: INTEGER
		do
			if target.valid_index (start_index) then
				count := target.count.min (end_index) - start_index + 1
				i := start_index + area_first_index - 1
				i_final := i + count
				if attached area as l_area then
					from until i = i_final or Result loop
						Result := l_area [i] = uc
						i := i + 1
					end
				end
			end
		end

feature -- Measurement

	latin_1_count: INTEGER
		local
			i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i loop
				if l_area.item (i).natural_32_code <= 0xFF then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		local
			i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i or else l_area [i] /= uc loop
				i := i + 1
			end
			Result := i - area_first_index
		end

	leading_white_count: INTEGER
		local
			i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			if attached Unicode_property as p then
				from i := area_first_index until i > last_i or else not p.is_space (l_area [i]) loop
					i := i + 1
				end
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
			if attached Unicode_property as p then
				from i := area_last_index until i < first_i or else not p.is_space (l_area [i]) loop
					i := i - 1
				end
			end
			Result := area_last_index - i
		end

feature {NONE} -- Implementation

	i_th_character_8 (a_area: like area; i: INTEGER): CHARACTER_8
		local
			uc: CHARACTER_32
		do
			uc := a_area [i]
			if uc.is_character_8 then
				Result := uc.to_character_8
			else
				Result := Substitute
			end
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
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_i_th_eiffel_identifier (a_area, i, case_code, first_i)
		end

end