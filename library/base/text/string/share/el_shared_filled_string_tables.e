note
	description: "[
		Shared instances of tables conforming to ${EL_FILLED_STRING_TABLE [READABLE_STRING_GENERAL]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_SHARED_FILLED_STRING_TABLES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Character_string_32_table: EL_FILLED_STRING_32_TABLE
		once
			create Result.make
		end

	Character_string_8_table: EL_FILLED_STRING_8_TABLE
		once
			create Result.make
		end

	Character_string_table: EL_FILLED_ZSTRING_TABLE
		once
			create Result.make
		end

end