note
	description: "[$source CHARACTER_32] iterator for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-18 10:28:49 GMT (Thursday 18th March 2021)"
	revision: "2"

class
	EL_ZSTRING_ITERATION_CURSOR

inherit
	READABLE_INDEXABLE_ITERATION_CURSOR [CHARACTER_32]
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
			c: CHARACTER; i: INTEGER
		do
			i := target_index
			c := area [i - 1]
			if c = Unencoded_character then
				Result := unencoded.item (i)
			else
				Result := codec.as_unicode_character (c)
			end
		end

	z_code: NATURAL
		local
			c: CHARACTER; i: INTEGER
		do
			i := target_index
			c := area [i - 1]
			if c = Unencoded_character then
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