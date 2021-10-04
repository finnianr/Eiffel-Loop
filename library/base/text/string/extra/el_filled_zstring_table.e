note
	description: "Table of filled strings of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-04 12:41:38 GMT (Monday 4th October 2021)"
	revision: "1"

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