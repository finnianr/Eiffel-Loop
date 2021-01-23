note
	description: "Iterator for [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-22 10:02:29 GMT (Friday 22nd January 2021)"
	revision: "2"

class
	EL_SUBSTRING_32_ARRAY_ITERATOR

inherit
	PART_COMPARABLE
		redefine
			default_create
		end

	DEBUG_OUTPUT undefine default_create end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			area := Default_area
		end

feature -- Comparison

	adjacent_to (other: like Current): BOOLEAN
		-- `True' if `other' is contiguous with `Current'
		do
			Result := upper + 1 = other.lower
		end

	is_less alias "<" (other: like Current): BOOLEAN
		do
			Result := upper < other.lower
		end

feature -- Access

	debug_output: STRING_32
		local
			i, i_final: INTEGER
		do
			if after then
				create Result.make_empty
			else
				create Result.make (character_count + 20)
				i_final := offset + character_count
				from i := offset until i = i_final loop
					Result.append_code (area [i])
					i := i + 1
				end
				Result.append_string_general (": ")
				Result.append_integer (lower)
				Result.append_character (':')
				Result.append_integer (upper)
			end
		end

feature -- Measurement

	character_count: INTEGER
		do
			Result := upper - lower + 1
		end

	count: INTEGER
		-- substring count
		do
			Result := area.item (0).to_integer_32
		end

	index: INTEGER

	index_final: INTEGER

	lower: INTEGER
		do
			Result := area.item (index).to_integer_32
		end

	offset: INTEGER
		do
			Result := index_final
		end

	upper: INTEGER
		do
			Result := area.item (index + 1).to_integer_32
		end

feature -- Status query

	after: BOOLEAN
		do
			Result := index = index_final
		end

feature -- Element change

	start (a_area: like area)
		do
			area := a_area
			index := 1; index_final := count * 2 + 1
		end

feature -- Cursor movement

	back
		do
			index := index - 1
		end

	forth
		do
			index := index + 2
		end

feature {EL_SUBSTRING_32_ARRAY} -- Access

	area: SPECIAL [NATURAL]

feature {NONE} -- Constants

	Default_area: SPECIAL [NATURAL]
		once
			create Result.make_filled (0, 1)
		end

end