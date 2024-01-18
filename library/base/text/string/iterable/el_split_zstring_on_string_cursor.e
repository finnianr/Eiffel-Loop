note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_STRING_CURSOR [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-19 19:58:31 GMT (Wednesday 19th July 2023)"
	revision: "4"

class
	EL_SPLIT_ZSTRING_ON_STRING_CURSOR

inherit
	EL_SPLIT_ON_STRING_CURSOR [ZSTRING]
		rename
			separator as general_separator
		redefine
			is_white_space, initialize, set_separator_start
		end

create
	make

feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

	initialize
		do
			if attached {ZSTRING} general_separator as l_seperator then
				separator := l_seperator
			else
				create separator.make_from_general (general_separator)
			end
		end

	set_separator_start
		do
			separator_start := target.substring_index (separator, separator_end + 1)
		end

feature {NONE} -- Internal attributes

	separator: ZSTRING

end