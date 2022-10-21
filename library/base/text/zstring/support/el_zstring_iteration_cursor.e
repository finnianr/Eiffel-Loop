note
	description: "[$source CHARACTER_32] iterator for [$source EL_READABLE_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-21 7:22:58 GMT (Friday 21st October 2022)"
	revision: "5"

class
	EL_ZSTRING_ITERATION_CURSOR

inherit
	STRING_32_ITERATION_CURSOR
		rename
			area as unencoded_area
		redefine
			item, make, target
		end

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

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Access

	target: EL_READABLE_ZSTRING

	area: SPECIAL [CHARACTER]

	unencoded: EL_UNENCODED_CHARACTERS_INDEX

end