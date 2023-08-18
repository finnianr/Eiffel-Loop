note
	description: "[$source CHARACTER_8_REF] with conversion to [$source STRING_8] by `*' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 6:31:54 GMT (Thursday 17th August 2023)"
	revision: "4"

class
	EL_CHARACTER_8

inherit
	CHARACTER_8_REF

	EL_8_BIT_IMPLEMENTATION

	EL_SHARED_FILLED_STRING_TABLES

create
	make, default_create

convert
	make ({CHARACTER_8}), item: {CHARACTER_8}

feature {NONE} -- Initialization

	make (c: CHARACTER_8)
		do
			set_item (c)
		end

feature -- Access

	multiplied alias "*" (n: INTEGER): STRING_8
		do
			Result := Character_string_8_table.item (item, n)
		end

	joined (a, b: READABLE_STRING_8): STRING_8
		-- `a' and `b' strings joined by `item' character
		do
			create Result.make (a.count + b.count + 1)
			Result.append_string_general (a)
			Result.append_character (item)
			Result.append_string_general (b)
		end

	as_zstring (n: INTEGER): ZSTRING
		-- multiplied as shared `ZSTRING'
		do
			Result := Character_string_table.item (item, n)
		end

	as_string_32 (n: INTEGER): STRING_32
		-- multiplied as shared `STRING_32'
		do
			Result := Character_string_32_table.item (item, n)
		end
end