note
	description: "Table of filled strings of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

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