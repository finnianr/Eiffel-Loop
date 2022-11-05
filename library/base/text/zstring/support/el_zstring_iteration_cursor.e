note
	description: "[$source CHARACTER_32] iterator for [$source EL_READABLE_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 8:15:29 GMT (Saturday 5th November 2022)"
	revision: "6"

class
	EL_ZSTRING_ITERATION_CURSOR

inherit
	STRING_32_ITERATION_CURSOR
		rename
			area as unencoded_area
		redefine
			item, make, target
		end

	EL_STRING_ITERATION_CURSOR

	EL_ZCODE_CONVERSION

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Initialization

	make (a_target: EL_READABLE_ZSTRING)
		do
			Precursor (a_target)
			area := a_target.area
			create unencoded.make (a_target.unencoded_area)
		end

feature -- Access

	item: CHARACTER_32
		local
			code: INTEGER; i: INTEGER
		do
			i := target_index
			code := area [i - 1].code
			if code = Substitute_code then
				Result := unencoded.item (i)
			elseif code <= Max_7_bit_code then
				Result := code.to_character_32
			else
				Result := Unicode_table [code]
			end
		end

	z_code: NATURAL
		local
			c: CHARACTER; i: INTEGER
		do
			i := target_index
			c := area [i - 1]
			if c = Substitute then
				Result := unencoded.z_code (i)
			else
				Result := c.natural_32_code
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
		do
			Result := target.leading_occurrences (uc)
		end

	leading_white_count: INTEGER
		do
			Result := target.leading_white_space
		end

	trailing_white_count: INTEGER
		do
			Result := target.trailing_white_space
		end

feature -- Status query

	all_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		local
			c_8: EL_CHARACTER_8_ROUTINES
		do
			if not target.has_mixed_encoding then
				Result := c_8.is_ascii_area (area, area_first_index, area_last_index)
			end
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Access

	target: EL_READABLE_ZSTRING

	area: SPECIAL [CHARACTER]

	unencoded: EL_UNENCODED_CHARACTERS_INDEX

end