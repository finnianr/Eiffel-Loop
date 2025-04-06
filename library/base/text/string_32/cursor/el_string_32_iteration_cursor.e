note
	description: "External forward one-step iteration cursor for ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 6:12:38 GMT (Sunday 6th April 2025)"
	revision: "24"

class
	EL_STRING_32_ITERATION_CURSOR

inherit
	EL_STRING_ITERATION_CURSOR

	STRING_32_ITERATION_CURSOR
		rename
			make as set_target,
			area_first_index as index_lower,
			area_last_index as index_upper
		export
			{EL_SHARED_STRING_32_CURSOR, STRING_HANDLER} area, index_lower, index_upper
		end

	EL_STRING_BIT_COUNTABLE [STRING_32]

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
			area.do_if_in_bounds (agent Result.extend, included, index_lower, index_upper)
			Result.trim
		end

feature -- Basic operations

	append_to (destination: like area; source_index, n: INTEGER)
		do
			destination.copy_data (area, source_index + index_lower, destination.count, n)
		end

feature -- Measurement

	latin_1_count: INTEGER
		local
			i, last_i: INTEGER; l_area: like area
		do
			last_i := index_upper; l_area := area
			from i := index_lower until i > last_i loop
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
			last_i := index_upper; l_area := area
			from i := index_lower until i > last_i or else l_area [i] /= uc loop
				i := i + 1
			end
			Result := i - index_lower
		end

	target_count: INTEGER
		do
			Result := target.count
		end

	trailing_white_count: INTEGER
		local
			i, first_i: INTEGER; l_area: like area
		do
			first_i := index_lower; l_area := area
			if attached Unicode_property as p then
				from i := index_upper until i < first_i or else not p.is_space (l_area [i]) loop
					i := i - 1
				end
			end
			Result := index_upper - i
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