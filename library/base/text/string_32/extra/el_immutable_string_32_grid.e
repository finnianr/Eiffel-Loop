note
	description: "[
		2 dimensional array of ${IMMUTABLE_STRING_32} strings that share the same
		comma separated text of a ${STRING_32} manifest constant
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 7:06:35 GMT (Sunday 6th April 2025)"
	revision: "7"

class
	EL_IMMUTABLE_STRING_32_GRID

inherit
	EL_IMMUTABLE_STRING_GRID [STRING_32, IMMUTABLE_STRING_32]
		rename
			extended_string as super_readable_32
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

	new_table: EL_HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
		do
			create Result.make_equal (height)
		end
end