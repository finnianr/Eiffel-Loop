note
	description: "[
		[$source EL_ITERABLE_SPLIT_CURSOR] implemented with [$source CHARACTER_32] separator
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_SPLIT_ON_CHARACTER_CURSOR [S -> READABLE_STRING_GENERAL]

inherit
	EL_ITERABLE_SPLIT_CURSOR [S, CHARACTER_32]

create
	make

feature {NONE} -- Implementation

	set_separator_start
		do
			separator_start := target.index_of (separator, separator_end + 1)
		end

feature {NONE} -- Constants

	Separator_count: INTEGER = 1
end