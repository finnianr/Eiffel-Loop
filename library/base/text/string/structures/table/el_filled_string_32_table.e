note
	description: "Table of filled strings of type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-17 12:23:34 GMT (Sunday 17th October 2021)"
	revision: "2"

class
	EL_FILLED_STRING_32_TABLE

inherit
	EL_FILLED_STRING_TABLE [STRING_32]

create
	make

feature {NONE} -- Implementation

	new_filled (uc: CHARACTER_32; n: INTEGER): STRING_32
		do
			create Result.make_filled (uc, n)
		end
end