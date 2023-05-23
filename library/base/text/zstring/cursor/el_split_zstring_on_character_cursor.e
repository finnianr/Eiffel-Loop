note
	description: "[
		Optimized implementation of [$source EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-23 9:33:07 GMT (Tuesday 23rd May 2023)"
	revision: "3"

class
	EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [ZSTRING]
		redefine
			is_white_space, initialize, set_separator_start
		end

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

	initialize
		do
			separator_zcode := Codec.as_z_code (separator)
		end

	set_separator_start
		do
			separator_start := target.index_of_z_code (separator_zcode, separator_end + 1)
		end

feature {NONE} -- Internal attributes

	separator_zcode: NATURAL

end