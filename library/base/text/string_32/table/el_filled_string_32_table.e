note
	description: "Table of filled strings of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:51:14 GMT (Tuesday 20th August 2024)"
	revision: "5"

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