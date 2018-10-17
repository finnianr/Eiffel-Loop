note
	description: "Common constants for class STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 14:33:50 GMT (Wednesday 17th October 2018)"
	revision: "5"

class
	EL_STRING_32_CONSTANTS

feature {NONE} -- STRING_32

	Ellipsis_string_32: STRING_32
		once
			create Result.make_filled ('.', 2)
		end

	Empty_string_32: STRING_32
		once
			create Result.make_empty
		end

	character_string_32 (uc: CHARACTER_32): STRING_32
		do
			if Character_string_32_table.has_key (uc) then
				Result := Character_string_32_table.found_item
			else
				create Result.make_filled (uc, 1)
				Character_string_32_table.extend (Result, uc)
			end
		end

feature {NONE} -- Constants

	Character_string_32_table: HASH_TABLE [STRING_32, CHARACTER_32]
		once
			create Result.make (7)
		end

	frozen String_32_pool: EL_STRING_POOL [STRING_32]
		once
			create Result.make (3)
		end

invariant
	string_32_always_empty: Empty_string_32.is_empty
end
