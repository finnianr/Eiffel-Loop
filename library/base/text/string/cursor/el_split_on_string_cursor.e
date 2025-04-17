note
	description: "[
		${EL_ITERABLE_SPLIT_CURSOR} implemented with ${READABLE_STRING_GENERAL} separator
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:17:37 GMT (Wednesday 16th April 2025)"
	revision: "8"

deferred class
	EL_SPLIT_ON_STRING_CURSOR [RSTRING -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE]

inherit
	EL_ITERABLE_SPLIT_CURSOR [RSTRING, CHAR, READABLE_STRING_GENERAL]
		redefine
			separator_count
		end

feature {NONE} -- Implementation

	separator_count: INTEGER
		do
			Result := separator.count
		end

	set_separator_start
		do
			separator_start := target.substring_index (separator, separator_end + 1)
		end

end