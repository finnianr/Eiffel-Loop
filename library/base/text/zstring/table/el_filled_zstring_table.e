note
	description: "Table of filled strings of type ${EL_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_FILLED_ZSTRING_TABLE

inherit
	EL_FILLED_STRING_TABLE [ZSTRING]

create
	make

feature {NONE} -- Implementation

	new_filled (uc: CHARACTER_32; n: INTEGER): ZSTRING
		do
			create Result.make_filled (uc, n)
		end
end