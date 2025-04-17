note
	description: "[
		${EL_ITERABLE_SPLIT_CURSOR} implemented with ${CHARACTER_32} separator
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:17:58 GMT (Wednesday 16th April 2025)"
	revision: "8"

deferred class
	EL_SPLIT_ON_CHARACTER_CURSOR [RSTRING -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE]

inherit
	EL_ITERABLE_SPLIT_CURSOR [RSTRING, CHAR, CHAR]

feature {NONE} -- Implementation

	set_separator_start
		deferred
		end

end