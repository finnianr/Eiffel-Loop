note
	description: "[
		2 dimensional array of ${IMMUTABLE_STRING_32} strings that share the same
		comma separated text of a ${STRING_32} manifest constant
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:46:09 GMT (Tuesday 20th August 2024)"
	revision: "5"

class
	EL_IMMUTABLE_STRING_32_GRID

inherit
	EL_IMMUTABLE_STRING_GRID [STRING_32, IMMUTABLE_STRING_32]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

create
	make

feature {NONE} -- Implementation

	new_split_list (str: STRING_32): EL_SPLIT_IMMUTABLE_STRING_32_LIST
		do
			create Result.make_shared_adjusted (str, ',', {EL_SIDE}.Left)
		end

	new_table: HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
		do
			create Result.make_equal (height)
		end
end