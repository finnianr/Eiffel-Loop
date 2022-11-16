note
	description: "External forward one-step iteration cursor for [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_STRING_32_ITERATION_CURSOR

inherit
	STRING_32_ITERATION_CURSOR
		export
			{EL_SHARED_STRING_32_CURSOR} area, area_first_index, area_last_index, make
		end

	EL_STRING_ITERATION_CURSOR

	EL_SHARED_UNICODE_PROPERTY

create
	make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make ("")
		end

feature -- Transforms

	filtered (included: PREDICATE [CHARACTER_32]): STRING_32
		do
			create Result.make (target.count)
			area.do_if_in_bounds (agent Result.extend, included, area_first_index, area_last_index)
			Result.trim
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

end