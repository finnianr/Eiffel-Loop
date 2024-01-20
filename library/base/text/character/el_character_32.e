note
	description: "${CHARACTER_32_REF} with conversion to ${ZSTRING} by `*' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_CHARACTER_32

inherit
	CHARACTER_32_REF

	EL_SHARED_FILLED_STRING_TABLES

	EL_32_BIT_IMPLEMENTATION

create
	make_8, make_32, default_create

convert
-- to
	make_8 ({CHARACTER_8}), make_32 ({CHARACTER_32}),

-- from
	to_string: {READABLE_STRING_GENERAL, ZSTRING, READABLE_STRING_32, EL_READABLE_ZSTRING},
	item: {CHARACTER_32}

feature {NONE} -- Initialization

	make_8 (c: CHARACTER_8)
		do
			make_32 (c)
		end

	make_32 (uc: CHARACTER_32)
		do
			set_item (uc)
		end

feature -- Access

	multiplied alias "*" (n: INTEGER): ZSTRING
		do
			Result := Character_string_table.item (item, n)
		end

	joined (a, b: READABLE_STRING_GENERAL): ZSTRING
		-- `a' and `b' strings joined by `item' character
		do
			create Result.make (a.count + b.count + 1)
			Result.append_string_general (a)
			Result.append_character (item)
			Result.append_string_general (b)
		end

	as_string_8 (n: INTEGER): STRING_8
		-- multiplied as shared `STRING_8'
		do
			Result := Character_string_8_table.item (item.to_character_8, n)
		end

	as_string_32 (n: INTEGER): STRING_32
		-- multiplied as shared `STRING_32'
		do
			Result := Character_string_32_table.item (item, n)
		end

	to_string: ZSTRING
		do
			Result := multiplied (1)
		end

end