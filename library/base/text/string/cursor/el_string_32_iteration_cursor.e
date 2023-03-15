note
	description: "External forward one-step iteration cursor for [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 12:02:03 GMT (Wednesday 15th March 2023)"
	revision: "9"

class
	EL_STRING_32_ITERATION_CURSOR

inherit
	STRING_32_ITERATION_CURSOR
		export
			{EL_SHARED_STRING_32_CURSOR, STRING_HANDLER} area, area_first_index, area_last_index, make
		end

	EL_STRING_ITERATION_CURSOR

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

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		do
			destination.copy_data (area, source_index + area_first_index, destination.count, n)
		end

	parse (convertor: STRING_TO_NUMERIC_CONVERTOR; type: INTEGER)
		local
			i, last_i: INTEGER; l_area: like area
		do
			convertor.reset (type)
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i loop
				convertor.parse_character (l_area [i].to_character_8)
				i := i + 1
			end
		end

feature -- Status query

	all_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		local
			c_32: EL_CHARACTER_32_ROUTINES
		do
			Result := c_32.is_ascii_area (area, area_first_index, area_last_index)
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

	i_th_character_32 (a_area: SPECIAL [CHARACTER_32]; i: INTEGER): CHARACTER_32
		do
			Result := a_area [i]
		end

end