note
	description: "[
		[$source EL_ITERABLE_SPLIT_CURSOR] implemented with [$source READABLE_STRING_GENERAL] separator
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 10:11:04 GMT (Friday 26th November 2021)"
	revision: "1"

class
	EL_SPLIT_ON_STRING_CURSOR [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_ITERABLE_SPLIT_CURSOR [S, READABLE_STRING_GENERAL]

create
	make

feature {NONE} -- Implementation

	set_separator_start
		do
			separator_start := target.substring_index (separator, separator_end + 1)
		end

	separator_count: INTEGER
		do
			Result := separator.count
		end
end