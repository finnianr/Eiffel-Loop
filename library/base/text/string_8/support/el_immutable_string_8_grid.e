note
	description: "[
		2 dimensional array of ${IMMUTABLE_STRING_8} strings that share the same
		comma separated text of a ${STRING_8} manifest constant
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:54:26 GMT (Monday 23rd September 2024)"
	revision: "6"

class
	EL_IMMUTABLE_STRING_8_GRID

inherit
	EL_IMMUTABLE_STRING_GRID [STRING_8, IMMUTABLE_STRING_8]
		undefine
			bit_count
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

create
	make

feature {NONE} -- Implementation

	new_split_list (str: STRING_8): EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_shared_adjusted (str, ',', {EL_SIDE}.Left)
		end

	new_table: EL_HASH_TABLE [IMMUTABLE_STRING_8, IMMUTABLE_STRING_8]
		do
			create Result.make_equal (height)
		end

end