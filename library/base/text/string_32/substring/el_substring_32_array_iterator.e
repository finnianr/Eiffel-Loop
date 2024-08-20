note
	description: "Iterator for ${EL_SUBSTRING_32_ARRAY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_SUBSTRING_32_ARRAY_ITERATOR

inherit
	PART_COMPARABLE
		redefine
			default_create
		end

	DEBUG_OUTPUT undefine default_create end

	EL_SUBSTRING_32_ARRAY_IMPLEMENTATION
		rename
			start as array_iterator
		export
			{NONE} all
		undefine
			default_create
		end

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
					Result.append_character (area [i])
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
		local
			l_area: like area; i: INTEGER
		do
			l_area := area; i := index
			Result := value (l_area, i + 1) - value (l_area, i) + 1
		end

	count: INTEGER
		-- substring count
		do
			Result := value (area, 0)
		end

	index: INTEGER

	index_final: INTEGER

	lower: INTEGER
		do
			Result := lower_bound (area, index)
		end

	offset: INTEGER
		do
			Result := index_final
		end

	upper: INTEGER
		do
			Result := upper_bound (area, index)
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
			index := 1; index_final := first_index (area)
		end

feature -- Cursor movement

	back
		do
			index := index - 2
		end

	forth
		do
			index := index + 2
		end

feature {EL_SUBSTRING_32_ARRAY} -- Access

	area: SPECIAL [CHARACTER_32]

feature {NONE} -- Constants

	Default_area: SPECIAL [CHARACTER_32]
		once
			create Result.make_filled ('%U', 1)
		end

end