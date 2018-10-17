note
	description: "Common constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 14:34:22 GMT (Wednesday 17th October 2018)"
	revision: "5"

class
	EL_ZSTRING_CONSTANTS

feature {NONE} -- ZSTRING

	character_string (uc: CHARACTER_32): ZSTRING
		do
			if Character_string_table.has_key (uc) then
				Result := Character_string_table.found_item
			else
				create Result.make_filled (uc, 1)
				Character_string_table.extend (Result, uc)
			end
		end

	Ellipsis_string: ZSTRING
		once
			create Result.make_filled ('.', 2)
		end

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	frozen String_pool: EL_STRING_POOL [ZSTRING]
		once
			create Result.make (3)
		end

	Character_string_table: HASH_TABLE [ZSTRING, CHARACTER_32]
		once
			create Result.make (7)
		end

invariant
	string_always_empty: Empty_string.is_empty
	ellipsis_size_is_two: Ellipsis_string.count = 2
end
